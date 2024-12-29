# ShaguJunk

This addon can automatically delete and vendor specified items. It comes with four lists.
A vendor-list that automatically sells all items on it to a merchant and a several delete-list that
automatically deletes the specified items whenever a new item is pushed into the inventory.

The lists can by displayed by typing `/junk ls`.  
You can add to the different lists using the following commands:
- `/junk vendor ITEMNAME` for the vendor list.
- `/junk delete ITEMNAME` for the general delete list.
- `/junk dungeon ITEMNAME` for items to delete only while inside a dungeon. 
- `/junk temp ITEMNAME` for items to delete until new game session (or plugins are reloaded).

Instead of typing the item name, one can also use item links (shift-click the item).

You can also specify a limit for grey items' vendor value in silver using `/junk grey SILVERVALUE`,
which will delete any item with stack value below this limit.  
As example, setting the limit to 10 silver using `/junk grey 10` and you pick up **Cross-stitched Sandals** 
which is worth 4 silver & 89 copper it will be deleted  
But picking up **Seeping Gizzard** which individually sells for 3 silver but stacks to 5 to combined 15 silver will be ignored

Removing items from the list can be done via `/junk rm ID`, where ID is the identifier number
that is shown in `/junk ls`.

If the `/junk` command is already occupied by another addon, the `/sjunk` command can be used.

![preview](junk-vendor-ls-rm.gif)

**WARNING: USE AT YOUR OWN RISK**

## Installation (Vanilla, 1.12)
1. Download **[Latest Version](https://github.com/shagu/ShaguJunk/archive/master.zip)**
2. Unpack the Zip file
3. Rename the folder "ShaguJunk-master" to "ShaguJunk"
4. Copy "ShaguJunk" into Wow-Directory\Interface\AddOns
5. Restart Wow

## Installation (The Burning Crusade, 2.4.3)
1. Download **[Latest Version](https://github.com/shagu/ShaguJunk/archive/master.zip)**
2. Unpack the Zip file
3. Rename the folder "ShaguJunk-master" to "ShaguJunk-tbc"
4. Copy "ShaguJunk-tbc" into Wow-Directory\Interface\AddOns
5. Restart Wow

## Commands

* **/junk**
* **/sjunk**
