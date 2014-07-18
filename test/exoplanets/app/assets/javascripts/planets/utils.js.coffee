
window.ex = {}

ex.deg2rad = (a) -> a * Math.PI / 180
ex.rad2deg = (a) -> a / Math.PI * 180

window.requestAnimationFrame = window.requestAnimationFrame or window.mozRequestAnimationFrame or window.webkitRequestAnimationFrame or window.oRequestAnimationFrame or (cb) -> setTimeout cb, 1000 / 60

