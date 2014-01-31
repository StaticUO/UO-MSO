
The Shortcuts ('sc') Folder
---------------------------

This folder is for all files, functions, or external code called from the editor.

It's purpose is to make file paths in the editor shorter.

Do not use this folder to contain entire components; instead use it to 'link' to the respective module.

---

For example, it's much easier to put
	"this execVM 'sc\init.sqf';" 
than to put
	"this execVM 'mod\player\init.sqf';"
in a unit's init field.
