# ExileTools In-Game Price Comparison Macro

## Quickly check prices and availability of items without leaving the game!

*What it Does:* Press CTRL-p while hovering over an item to open a tooltip with a text report of the best prices and availability for that item in Chaos Equivalent Values (CEV). Simple, easy, and efficient.

*Note:* At this time, the ^i interactive search feature is disabled. This will be rebuilt with a new backend as well, however no changes will be needed to the macro to make it work.

## Requires AutoHotKey from [ahkscript.org](http://ahkscript.org/download/) NOT autohotkey.com!

# Updating Leagues

To see a list of active leagues that the macro can use, go to http://api.exiletools.com/ladder and scroll down to active leagues. This macro uses "friendly short names" rather than full league names.

As of 2016/06, the active leagues include `standard`, `hardcore`, `prophecy`, and `prophecyhc`

# How to Install

1. Download AutoHotKey 1.1.22+ from ahkscript.org (not autohotkey.com - that's different!).
2. [Download poe_price_macro.ahk](https://raw.githubusercontent.com/trackpete/exiletools-price-macro/master/poe_price_macro.ahk) and save it anywhere on your computer.
3. Open the `poe_price_macro.ahk` file in an editor such as Notepad (right-click, Edit Script)
4. Optional: Read through all the information in the script to learn about stuff
5. Find the Variables section and set the `LeagueName` variable to the correct one for you
6. Optional: Change other global variables if desired, such as `showDays`, etc. You can also change the macro hotkey.
7. Save the file, then double click it to load it... then play Path of Exile!

*Please note:* You must play Path of Exile in Windowed Fullscreen or Windowed mode for the tooltip to show up. In Windows 10 you may need to "run-as Administrator."

# Using the Macro

There are two macros included with the script. The macros will only run if Path of Exile is the foreground window. By default, they work as follows:

* `CTRL-p` : Generates a price report for the item based on information submitted to my indexer.
* `CTRL-i` : Opens an interactive search window. This is a base for a future feature and will not do anything currently.

Notes for Maps: Due to complications with map names and new maps in The Awakening, the report will show pricing information for all maps of the same level, rather than the specific Map itself.

# Understanding the Results:

Results are primarily returned in Chaos Equivalent Values (CEV). These values are not absolute and are intended for reference and comparison only. Remember, if a seller lists an item for Orb of Fusing then they probably don't want Chaos, even converted to a fair rate. Also, currency exchange rates fluctuate and may change on a day to day basis. You can see the rates used by my Price API at any time by going to http://exiletools.com/rates. It will not always reflect the exact rates for the time and league, thus, again, is for reference only.

*Why does it never work for Rare items?* Sorry, as of the release of POE 2.1 (Talisman leagues), some of the item formatted was broken. I'm working on changing the back-end to handle this, but haven't finished. For now the macro is only accurate for Unique Items. You can follow along with the back-end repair by watching the [issues in the exiletools-indexer project](https://github.com/trackpete/exiletools-indexer/issues/66).

*What determines the value?* The primary value shown is based on the 10th Percentile Lowest Price, and is designed to show the lowest price at which multiple matching items are available. This is typically a fair value, but not necessarily the lowest price. The Lowest Price shown is literally that, however due to market manipulation recently, sometimes the Lowest Price should be ignored (especially if it is significantly lower than the 10th Percentile).

*What about stats for Uniques?* Item stats are not currently figured into the queries for Uniques. For many low end items this does not m atter, however for some items the rolls on the Explicit Mods will greatly effect it's perceived value by the playerbase. Some awareness of how these stat s change value may be necessary to correctly price more valuable items. Eventually I will add stat range and Corruption to Unique items, but currently it is not supported.

*What is "Added Recently" and "Gone Recently?"* This shows the number of matching items added in the last three days, as well as items that may have been sold in the last three days because they used to be in a shop and were removed. Items where the Gone Recently numb er is close to the Added Recently number indicate they are in high demand, while items with many Added Recently and few Gone Recently are not very likely to sell. All numbers shown are based on items listed in the Shop Forums with buyouts.

*How do I share the results in chat?* A summary sentence will be automatically copied to your clipboard, which you can just paste into chat as you'd like with ^v!

# Real Tool-Tip Examples

![Examples](http://exiletools.com/img/price-examples.jpg)

# Known Issues

Known Issues:

* Rares are currently busted up. Sorry about this. Eventually I will fix it.
* The POE Item Info Script, which is totally awesome, is triggered automatically by the ^C sent by my macro. Then their tooltip format interacts weirdly with mine. I haven't fixed this yet, sorry.
* The ^i functionality isn't built on the new back-end, and 5L/6L data is not yet displayed in the results.
* Some non-standard mods will be ignored on item searches. Working on it.
* You may need to run-as Administrator on Windows 10
