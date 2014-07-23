package newprojectdialog;
import js.node.Mkdirp;
import bootstrap.ButtonManager;
import core.FileDialog;
import dialogs.ModalDialog;
import haxe.ds.StringMap;
import haxe.Timer;
import jQuery.JQuery;
import js.Browser;
import js.html.AnchorElement;
import js.html.ButtonElement;
import js.html.DivElement;
import js.html.Event;
import js.html.HeadingElement;
import js.html.InputElement;
import js.html.LabelElement;
import js.html.LIElement;
import js.html.MouseEvent;
import js.html.OptionElement;
import js.html.ParagraphElement;
import js.html.SelectElement;
import js.html.SpanElement;
import js.html.UListElement;
import watchers.LocaleWatcher;

/**
 * ...
 * @author AS3Boyan
 */
typedef ProjectData = {
    projectName:String,
    projectCompany:String,
    projectURL:String,
    projectPackage:String,
    projectLocation:String,
    projectLicense:String,
    createDirectory:Bool
}

class NewProjectDialog
{
	static var modalDialog:ModalDialog;
	
	static var list:SelectElement;
	static var selectedCategory:Category;
	static var description:ParagraphElement;
	static var helpBlock:ParagraphElement;
	static var projectName:InputElement;
	static var projectLocation:InputElement;
	static var createDirectoryForProject:InputElement;
	static var page1:DivElement;
	static var page2:DivElement;
	static var backButton:ButtonElement;
	static var textfieldsWithCheckboxes:StringMap<InputElement>;
	static var checkboxes:StringMap<InputElement>;
	static var nextButton:ButtonElement;
	
	static var categories:StringMap<Category> = new StringMap();
	static var tree:UListElement;
	
	static var categoriesArray:Array<Category> = new Array();
	static var lastProjectCategoryPath:String;
	
	public static function load():Void
	{
		modalDialog = new ModalDialog("New Project");
		
		var button:ButtonElement = Browser.document.createButtonElement();
		button.type = "button";
		button.className = "close";
		button.setAttribute("data-dismiss", "modal");
		button.setAttribute("aria-hidden", "true");
		button.innerHTML = "&times;";
		modalDialog.getHeader().appendChild(button);
		
		textfieldsWithCheckboxes = new StringMap();
		checkboxes = new StringMap();
		
		createPage1();
		modalDialog.getBody().appendChild(page1);
		
		createPage2();
		page2.style.display = "none";
		modalDialog.getBody().appendChild(page2);
		
		var buttonManager = ButtonManager.get();
		
		backButton = buttonManager.createButton("Back", true);
		
		modalDialog.getFooter().appendChild(backButton);
		
		nextButton = buttonManager.createButton("Next");
		
		backButton.onclick = function (e:MouseEvent)
		{
			if (backButton.className.indexOf("disabled") == -1)
			{
				showPage1();
			}
		}
		;
		
		nextButton.onclick = function (e:MouseEvent)
		{
			if (nextButton.className.indexOf("disabled") == -1)
			{
				showPage2();
			}
		}
		;
		
		modalDialog.getFooter().appendChild(nextButton);
		
		var finishButton:ButtonElement = buttonManager.createButton("Finish", false, false, true);
		
		finishButton.onclick = function (e:MouseEvent)
		{
			if (projectLocation.value == "") 
			{
				showPage2();
				projectLocation.focus();
				Alertify.log("Please specify location for your projects");
			}
			else if (page1.style.display != "none" || projectName.value == "" )
			{
				generateProjectName(createProject);
			}
			else
			{
				createProject();
			}
		}
		;
		
		modalDialog.getFooter().appendChild(finishButton);
		
		var cancelButton:ButtonElement = buttonManager.createButton("Cancel", false, true);
		
		modalDialog.getFooter().appendChild(cancelButton);
		
		var location:String = Browser.getLocalStorage().getItem("Location");
		
		if (location != null)
		{
			projectLocation.value = location;
		}
		
		loadData("Package");
		loadData("Company");
		loadData("License");
		loadData("URL");
		
		loadCheckboxState("Package");
		loadCheckboxState("Company");
		loadCheckboxState("License");
		loadCheckboxState("URL");
		loadCheckboxState("CreateDirectory");
		
		lastProjectCategoryPath = Browser.getLocalStorage().getItem("lastProject");
	}
	
	static function showPage1() 
	{
		new JQuery(page1).show(300);
		new JQuery(page2).hide(300);
		backButton.className = "btn btn-default disabled";
		nextButton.className = "btn btn-default";
	}
	
	static function showPage2() 
	{
		generateProjectName();
				
		new JQuery(page1).hide(300);
		new JQuery(page2).show(300);
		backButton.className = "btn btn-default";
		nextButton.className = "btn btn-default disabled";
	}
	
	inline static function getCheckboxData(key:String):String
	{
		var data:String = "";
		
		if (checkboxes.get(key).checked)
		{
			data = textfieldsWithCheckboxes.get(key).value;
		}
		
		return data;
	}
	
	static function createProject():Void
	{		
		var location = projectLocation.value;
		
		if (location != "" && projectName.value != "")
		{
			js.Node.fs.exists(location, function (exists:Bool):Void
			{
				if (!exists)
				{
					Mkdirp.mkdirpSync(location);
				}
					
				var item:Item = selectedCategory.getItem(list.value);
					
				saveProjectCategory();

				if (item.createProjectFunction != null)
				{
					var projectPackage:String = getCheckboxData("Package");
					var projectCompany:String = getCheckboxData("Company");
					var projectLicense:String = getCheckboxData("License");
					var projectURL:String = getCheckboxData("URL");

					var data:ProjectData = { 
						projectName: projectName.value,
						projectLocation: location,
						projectPackage: projectPackage,
						projectCompany: projectCompany,
						projectLicense: projectLicense,
						projectURL: projectURL,
						createDirectory: !selectedCategory.getItem(list.value).showCreateDirectoryOption || createDirectoryForProject.checked
						};
					
					item.createProjectFunction(data);

					Browser.getLocalStorage().setItem("Location", location);
				}

				//switch (selectedCategory) 
				//{
					//case "Haxe":

						//
						//project.type = Project.HAXE;
						//
						//switch (list.value) 
						//{
							//case "Flash Project":
								//project.target = "flash";
							//case "JavaScript Project":
								//project.target = "html5";
							//case "Neko Project":
								//project.target = "neko";
							//case "PHP Project":
								//project.target = "php";
							//case "C++ Project":
								//project.target = "cpp";
							//case "Java Project":
								//project.target = "java";
							//case "C# Project":
								//project.target = "csharp";
							//default:
								//
						//}
						//
						//var pathToMain:String  = js.Node.path.join(projectName.value, "src");
						//pathToMain = js.Node.path.join(pathToMain, "Main.hx");
						//
						//project.main = pathToMain;
					//case "OpenFL":
						//switch (list.value) 
						//{
							//case "OpenFL Project":		

							//case "OpenFL Extension":
								//createOpenFLProject(["extension", projectName.value]);
							//default:
								//
						//}
						//
						//project.type = Project.OPENFL;
						//project.target = "html5";
						//project.main = "project.xml";
					//case "OpenFL/Samples":
						//
						//createOpenFLProject([list.value]);
						//
						//project.type = Project.OPENFL;
						//project.target = "html5";
						//project.main = "project.xml";
					//default:
						//
				//}

				//Main.updateMenu();

				saveData("Package");
				saveData("Company");
				saveData("License");
				saveData("URL");

				saveCheckboxState("Package");
				saveCheckboxState("Company");
				saveCheckboxState("License");
				saveCheckboxState("URL");
				saveCheckboxState("CreateDirectory");

				hide();
			}
			);
		}
	}
	
	static private function saveProjectCategory():Void
	{
		var fullCategoryPath:String = "";
		
		var root:Bool = false;
		
		var parentCategory = selectedCategory;
		
		while (!root)
		{
			fullCategoryPath = parentCategory.name + "/" + fullCategoryPath;
			if (parentCategory.parent != null)
			{
				parentCategory = parentCategory.parent;
			}
			else 
			{
				root = true;
			}
		}
		
		fullCategoryPath += list.value;
		
		Browser.getLocalStorage().setItem("lastProject", fullCategoryPath);
	}
	
	private static function generateProjectName(?onGenerated:Dynamic):Void
	{		
		if (selectedCategory.getItem(list.value).nameLocked == false)
		{
			var value:String = StringTools.replace(list.value, "+", "p");
			value = StringTools.replace(value, "#", "sharp");
			value = StringTools.replace(value, " ", "");
			//
			//if (selectedCategory != "OpenFL")
			//{
			//	value = StringTools.replace(selectedCategory, "/", "") + value;
			//}
			//
			
			generateFolderName(projectLocation.value, value, 1, onGenerated);
		}
		else
		{
			projectName.value = list.value;
			updateHelpBlock();
			
			if (onGenerated != null)
			{
				onGenerated();
			}
		}
		
		
		if (selectedCategory.getItem(list.value).showCreateDirectoryOption)
		{
			createDirectoryForProject.parentElement.parentElement.style.display = "block";
		}
		else
		{
			createDirectoryForProject.parentElement.parentElement.style.display = "none";
		}
		
		projectName.disabled = selectedCategory.getItem(list.value).nameLocked;
	}
	
	public static function show():Void
	{		
		if (page1.style.display == "none")
		{
			backButton.click();
		}
		
		if (selectedCategory == null && categoriesArray.length > 0)
		{
			categoriesArray[0].select();
		}
		else 
		{
			selectedCategory.select(list.value);
		}
		
		modalDialog.show();
	}
	
	public static function hide():Void
	{
		modalDialog.hide();
	}
	
	public static function getCategory(name:String, ?position:Int):Category
	{
		var category:Category;
		
		if (!categories.exists(name))
		{
			category = createCategory(name);
			categories.set(name, category);
			
			category.setPosition(position);
			addCategoryToDocument(category);
		}
		else 
		{
			category = categories.get(name);
			
			if (position != null && category.position != position)
			{
				
			}
		}
		
		if (position != null && category.position != position)	
		{
			category.getElement().remove();
			categories.remove(name);

			category.setPosition(position);

			addCategoryToDocument(category);

			categories.set(name, category);
		}
		
		return category;
	}
	
	public static function loadProjectCategory():Void
	{
		if (lastProjectCategoryPath != null)
		{			
			var categoryNames:Array<String> = lastProjectCategoryPath.split("/");
			
				if (categories.exists(categoryNames[0]))
				{
					var category:Category = categories.get(categoryNames[0]);
					
					if (categoryNames.length > 2)
					{
						for (i in 1...categoryNames.length - 1)
						{							
							if (category.subcategories.exists(categoryNames[i]))
							{
								category = category.subcategories.get(categoryNames[i]);
								
								if (Lambda.has(category.getItems(), categoryNames[categoryNames.length - 1]))
								{
									category.select(categoryNames[categoryNames.length - 1]);
									lastProjectCategoryPath = null;
									
									new JQuery(category.element).children('ul.tree').show(300);
								}
							}
							else 
							{
								break;
							}
						}
					}
					else 
					{
						if (Lambda.has(category.getItems(), categoryNames[categoryNames.length - 1]))
						{
							category.select(categoryNames[categoryNames.length - 1]);
							lastProjectCategoryPath = null;
							
							new JQuery(category.element).children('ul.tree').show(300);
						}
					}
				}
		}
		
		//for (category in categories.iterator())
					//{
						//if (Lambda.count(category.subcategories) > 0)
						//{
							//
						//}
						//trace(category);
					//}
					
					//trace(list.value);
	}
	
	public static function addCategoryToDocument(category:Category):Void
	{
		if (category.position != null && categoriesArray.length > 0 && tree.childNodes.length > 0)
		{
			var currentCategory:Category;

			var added:Bool = false;

			for (i in 0...categoriesArray.length)
			{
				currentCategory = categoriesArray[i];

				if (currentCategory != category && currentCategory.position == null || category.position < currentCategory.position)
				{
					tree.insertBefore(category.getElement(), currentCategory.getElement());
					categoriesArray.insert(i, category);
					added = true;
					break;
				}
			}

			if (!added)
			{
				tree.appendChild(category.getElement());
				categoriesArray.push(category);
			}
		}
		else
		{
			tree.appendChild(category.getElement());
			categoriesArray.push(category);
		}
	}
	
	private static function generateFolderName(path:String, folder:String, n:Int, ?onGenerated:Dynamic):Void
	{		
		if (path != "" && folder != "")
		{
			js.Node.fs.exists(js.Node.path.join(path, folder + Std.string(n)), function (exists:Bool):Void
			{
				if (exists)
				{
					generateFolderName(path, folder, n + 1, onGenerated);
				}
				else 
				{
					projectName.value = folder + Std.string(n);
					updateHelpBlock();
					
					if (onGenerated != null)
					{
						onGenerated();
					}
				}
			}
			);
		}
		else
		{
			projectName.value = folder + Std.string(n);
			updateHelpBlock();
		}
	}
	
	private static function loadData(_text:String):Void
	{
		var text:String = Browser.getLocalStorage().getItem(_text);
		
		if (text != null)
		{
			textfieldsWithCheckboxes.get(_text).value = text;
		}
	}
	
	private static function saveData(_text:String):Void
	{
		if (checkboxes.get(_text).checked)
		{
			var value:String = textfieldsWithCheckboxes.get(_text).value;
			
			if (value != "")
			{
				Browser.getLocalStorage().setItem(_text, value);
			}
		}
	}
	
	private static function loadCheckboxState(_text:String):Void
	{
		var text:String = Browser.getLocalStorage().getItem(_text + "Checkbox");
		
		if (text != null)
		{
			checkboxes.get(_text).checked = js.Node.parse(text);
		}
	}
	
	private static function saveCheckboxState(_text:String):Void
	{
		Browser.getLocalStorage().setItem(_text + "Checkbox", js.Node.stringify(checkboxes.get(_text).checked));
	}
	
	private static function createPage1():DivElement
	{
		page1 = Browser.document.createDivElement();
		
		var well:DivElement = Browser.document.createDivElement();
		well.id = "new-project-dialog-well";
		well.className = "well";
		//well.style.overflow = "auto";
		//well.classList.add("pull-left");
		well.style.float = "left";
		well.style.width = "50%";
		well.style.height = "250px";
		well.style.marginBottom = "0";
		page1.appendChild(well);
		
		tree = Browser.document.createUListElement();
		tree.className = "nav nav-list";
		well.appendChild(tree);
		
		list = createList();
		list.style.float = "left";
		list.style.width = "50%";
		list.style.height = "250px";
		
		page1.appendChild(list);
		
		page1.appendChild(Browser.document.createBRElement());
		
		description = Browser.document.createParagraphElement();
		description.style.width = "100%";
		description.style.height = "50px";
		description.style.overflow = "auto";
		description.textContent = LocaleWatcher.getStringSync("Description");
		description.setAttribute("localeString", "Description");
		
		page1.appendChild(description);
		
		return page1;
	}
	
	private static function createPage2():DivElement
	{
		page2 = Browser.document.createDivElement();
		page2.style.padding = "15px";
		
		var row:DivElement = Browser.document.createDivElement();
		row.className = "row";
		
		projectName = Browser.document.createInputElement();
		projectName.type = "text";
		projectName.className = "form-control";
		projectName.placeholder = LocaleWatcher.getStringSync("Name");
		projectName.style.width = "100%";
		row.appendChild(projectName);
		
		page2.appendChild(row);
		
		row = Browser.document.createDivElement();
		row.className = "row";
		
		var inputGroup:DivElement = Browser.document.createDivElement();
		inputGroup.className = "input-group";
		inputGroup.style.display = "inline";
		row.appendChild(inputGroup);
		
		projectLocation = Browser.document.createInputElement();
		projectLocation.type = "text";
		projectLocation.className = "form-control";
		projectLocation.placeholder = LocaleWatcher.getStringSync("Location");
		projectLocation.style.width = "80%";
		inputGroup.appendChild(projectLocation);
		
		var browseButton:ButtonElement = Browser.document.createButtonElement();
		browseButton.type = "button";
		browseButton.className = "btn btn-default";
		browseButton.textContent = LocaleWatcher.getStringSync("Browse...");
		browseButton.style.width = "20%";
		
		browseButton.onclick = function (e:MouseEvent)
		{
			FileDialog.openFolder(function (path:String):Void
			{
				projectLocation.value = path;
				updateHelpBlock();
				
				Browser.getLocalStorage().setItem("Location", path);
			}
			);
		};
		
		inputGroup.appendChild(browseButton);
		
		page2.appendChild(row);
		
		createTextWithCheckbox(page2, "Package");
		createTextWithCheckbox(page2, "Company");
		createTextWithCheckbox(page2, "License");
		createTextWithCheckbox(page2, "URL");
		
		row = Browser.document.createDivElement();
		row.className = "row";
		
		var checkboxDiv:DivElement = Browser.document.createDivElement();
		checkboxDiv.className = "checkbox";
		row.appendChild(checkboxDiv);
		
		var label:LabelElement = Browser.document.createLabelElement();
		checkboxDiv.appendChild(label);
		
		createDirectoryForProject = Browser.document.createInputElement();
		createDirectoryForProject.type = "checkbox";
		createDirectoryForProject.checked = true;
		label.appendChild(createDirectoryForProject);
		
		checkboxes.set("CreateDirectory", createDirectoryForProject);
		
		createDirectoryForProject.onchange = function (e):Void
		{
			updateHelpBlock();
		};
		
		label.appendChild(Browser.document.createTextNode("Create directory for project"));
		
		page2.appendChild(row);
		
		row = Browser.document.createDivElement();
		
		helpBlock = Browser.document.createParagraphElement();
		helpBlock.className = "help-block";
		row.appendChild(helpBlock);
		
		projectLocation.onchange = function (e):Void
		{
			updateHelpBlock();
			generateFolderName(projectLocation.value, projectName.value, 1);
		};
		
		projectName.onchange = function (e):Void
		{			
			projectName.value = projectName.value.substr(0, 1).toUpperCase() + projectName.value.substr(1);
			updateHelpBlock();
		}
		
		page2.appendChild(row);
		
		return page2;
	}
	
	private static function updateHelpBlock():Void
	{
		if (projectLocation.value != "")
		{
			var str:String = "";
			
			//(selectedCategory != "Haxe" ||
			if ((!selectedCategory.getItem(list.value).showCreateDirectoryOption || createDirectoryForProject.checked == true) && projectName.value != "")
			{
				str = projectName.value;
			}
			
			helpBlock.innerText = LocaleWatcher.getStringSync("Project will be created in: ") + js.Node.path.join(projectLocation.value, str);
		}
		else
		{
			helpBlock.innerText = "";
		}
	}
	
	private static function createTextWithCheckbox(_page2:DivElement, _text:String):Void
	{
		var row:DivElement = Browser.document.createDivElement();
		row.className = "row";
		
		var inputGroup:DivElement = Browser.document.createDivElement();
		inputGroup.className = "input-group";
		row.appendChild(inputGroup);
		
		var inputGroupAddon:SpanElement = Browser.document.createSpanElement();
		inputGroupAddon.className = "input-group-addon";
		inputGroup.appendChild(inputGroupAddon);
		
		var checkbox:InputElement = Browser.document.createInputElement();
		checkbox.type = "checkbox";
		checkbox.checked = true;
		inputGroupAddon.appendChild(checkbox);
		
		checkboxes.set(_text, checkbox);
		
		var text:InputElement = Browser.document.createInputElement();
		text.type = "text";
		text.className = "form-control";
		text.placeholder = LocaleWatcher.getStringSync(_text);
		
		textfieldsWithCheckboxes.set(_text, text);
		
		checkbox.onchange = function (e)
		{
			if (checkbox.checked)
			{
				text.disabled = false;
			}
			else
			{
				text.disabled = true;
			}
		};
		
		inputGroup.appendChild(text);
		
		_page2.appendChild(row);
	}
	
	private static function createCategory(text:String):Category
	{		
		var li:LIElement = Browser.document.createLIElement();
		
		var category:Category = new Category(text, li);
			
		var a:AnchorElement = Browser.document.createAnchorElement();
		a.href = "#";
		
		a.addEventListener("click", function (e:MouseEvent):Void
		{
			updateListItems(category);
		}
		);
		
		var span = Browser.document.createSpanElement();
		span.className = "glyphicon glyphicon-folder-open";
		a.appendChild(span);
		
		span = Browser.document.createSpanElement();
		span.textContent = LocaleWatcher.getStringSync(text);
		span.setAttribute("localeString", text);
		span.style.marginLeft = "5px";
		a.appendChild(span);
		
		li.appendChild(a);
		
		return category;
	}
	
	public static function createSubcategory(text:String, category:Category):Void
	{
		var a:AnchorElement = cast(category.element.getElementsByTagName("a")[0], AnchorElement);
		a.className = "tree-toggler nav-header";
		
		a.onclick = function (e:MouseEvent):Void
		{
			new JQuery(category.element).children('ul.tree').toggle(300);
		};
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "nav nav-list tree";
		category.element.appendChild(ul);
		
		category.element.onclick = function (e:MouseEvent):Void
		{
			for (subcategory in category.subcategories.keys())
			{
				ul.appendChild(category.subcategories.get(subcategory).element);
			}
			
			e.stopPropagation();
			e.preventDefault();
			category.element.onclick = null;
			
			new JQuery(ul).show(300);
		};
		
		var subcategory:Category = createCategory(text);
		subcategory.parent = category;
		category.subcategories.set(text, subcategory);
	}
	
	public static function updateListItems(category:Category, ?item:String):Void
	{		
		selectedCategory = category;
		
		new JQuery(list).children().remove();
		
		setListItems(list, category.getItems(), item);
		
		checkSelectedOptions();
	}
	
	public static function createCategoryWithSubcategories(text:String, subcategories:Array<String>):LIElement
	{
		var li:LIElement = Browser.document.createLIElement();
		
		var category:Category = createCategory(text);
		
		var a:AnchorElement = cast(li.getElementsByTagName("a")[0], AnchorElement);
		a.className = "tree-toggler nav-header";
		
		a.onclick = function (e:MouseEvent):Void
		{
			new JQuery(li).children('ul.tree').toggle(300);
		};
		
		var ul:UListElement = Browser.document.createUListElement();
		ul.className = "nav nav-list tree";
		li.appendChild(ul);
		
		li.onclick = function (e:MouseEvent):Void
		{
			for (subcategory in subcategories)
			{
				ul.appendChild(createCategory(subcategory).element);
			}
			
			e.stopPropagation();
			e.preventDefault();
			li.onclick = null;
			
			new JQuery(ul).show(300);
		};
		
		return li;
	}
	
	private static function createList():SelectElement
	{
		var select:SelectElement = Browser.document.createSelectElement();
		select.size = 10;		
		
		select.onchange = function (e):Void
		{
			checkSelectedOptions();
		};
		
		select.ondblclick = function (e):Void
		{
			showPage2();
		};
		
		return select;
	}
	
	private static function checkSelectedOptions():Void
	{
		if (list.selectedOptions.length > 0)
		{
			var option:OptionElement = cast(list.selectedOptions[0], OptionElement);
			//updateDescription(selectedCategory, option.label);
		}
	}
	
	private static function updateDescription(category:String, selectedOption:String):Void
	{
		//switch (category) 
		//{
			//case "Haxe":
				//switch (selectedOption) 
				//{
					//["Flash Project", "JavaScript Project", "Neko Project", "PHP Project", "C++ Project", "Java Project", "C# Project"]
					//case "Flash Project":
						//description.textContent = selectedOption;
					//default:
						//
				//}
			//case "OpenFL":
			//case "OpenFL/Samples":
				//
			//default:
				//
		//}
		
		description.textContent = selectedOption;
	}
	
	private static function setListItems(list:SelectElement, items:Array<String>, ?selectedItem:String):Void
	{
		for (item in items)
		{
			list.appendChild(createListItem(item));
			
			//if (items[i] == selectedItem)
			//{
				//list.selectedIndex = i;
			//}
		}
		
		//if (selectedItem == null)
		//{
			list.selectedIndex = 0;
		//}
		
		checkSelectedOptions();
	}
	
	private static function createListItem(text:String):OptionElement
	{		
		var option:OptionElement = Browser.document.createOptionElement();
		option.textContent = LocaleWatcher.getStringSync(text);
		option.setAttribute("localeString", text);
		option.value = text;
		return option;
	}
	
}
