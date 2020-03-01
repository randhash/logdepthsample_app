Log-spaced depth profile generator app

Requires:
An installation of R
R packages: shiny, ggplot2
Windows OS (for batch shortcut)

Any recent version of R should work.
I made the app with R version 3.6.0, but I don't see a reason why it wouldn't work on other recent versions.

If you do not have the required R packages, use this command in the R console to install:

install.packages(c("shiny", "ggplot2"))

You can create a shortcut to access the app without having to launch R manually each time.
This method is only for Windows operating systems because of the use of the batch file.
However, the app itself works for any OS that supports R.
If you have Windows and want to create a shortcut, you need to edit the files logdepthsample.bat and run.R.

In run.R:
Change the variable called "path" to point to the directory containing the app files.

In logdepthsample.bat:
Change the first file path (in quotes) to the path of your R.exe file. It's probably somewhere in Program Files.

Once you have adjusted the files, right-click on logdepthsample.bat and create a shortcut from it.
Copy and paste the shortcut wherever you want.
The app should launch in your default browser when you double-click the shortcut.

If you cannot or do not want to use the shortcut method to use the app, you can open the file app.R in R and then run it.
The app should automatically open in your default browser.
If you receive errors, ensure you have the required R packages installed.