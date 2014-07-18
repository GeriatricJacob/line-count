#= require three
#= require_tree ../../../vendor/assets/javascripts/shaders
#= require_tree ../../../vendor/assets/javascripts/postprocessing

$ ->
  container = document.getElementById('stage')

  w = container.offsetWidth or window.innerWidth
  h = container.offsetHeight or window.innerHeight

  w = 640
  h = 380

  distance = 1000

  camera = new THREE.PerspectiveCamera(30, w / h, 1, 10000)
  camera.position.z = distance

  scene = new THREE.Scene()

  geometry = new THREE.SphereGeometry(200, 40, 30)

  uniforms = texture: { type: 't', value: THREE.ImageUtils.loadTexture('/images/0.png')}

  shader =
    vertexShader: '''
      varying vec3 vNormal;
      varying vec2 vUv;

      void main() {
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
        vNormal = normalize( normalMatrix * normal );
        vUv = uv;
      }
    '''
    fragmentShader: '''
      uniform sampler2D texture;
      varying vec3 vNormal;
      varying vec2 vUv;

      void main() {

        vec3 diffuse = texture2D( texture, vUv ).xyz;
        float intensity = 1.05 - dot( vNormal, vec3( 0.0, 0.0, 1.0 ) );
        vec3 atmosphere = vec3( 1.0, 1.0, 1.0 ) * pow( intensity, 3.0 );
        gl_FragColor = vec4( diffuse + atmosphere, 1.0 );
      }
    '''

  material = new THREE.ShaderMaterial({
    uniforms: uniforms
    vertexShader: shader.vertexShader
    fragmentShader: shader.fragmentShader
  })

  mesh = new THREE.Mesh(geometry, material)
  # mesh.matrixAutoUpdate = false
  scene.add(mesh)

  renderer = new THREE.WebGLRenderer({antialias: true})
  renderer.autoClear = true
  renderer.setClearColor(0x000000, 0.0)
  renderer.setSize(w, h)

  composer = new THREE.EffectComposer(renderer)
  renderPass = new THREE.RenderPass(scene, camera)
  # renderPass.renderToScreen = true
  composer.addPass(renderPass)

  bloom = new THREE.BloomPass()
  bloom.renderToScreen = true
  composer.addPass(bloom)

  # renderer.domElement.style.position = 'absolute'

  container.appendChild(composer.renderTarget.domElement)
  # container.appendChild(renderer.domElement)

  playing = true

  animate = ->
    # renderer.clear()
    # renderer.render(scene, camera)
    composer.render(0.1)
    mesh.rotation.y += 0.002

    setTimeout (-> requestAnimationFrame animate if playing), 0

  animate()






