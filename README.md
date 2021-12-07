# Case-Study-How-Does-a-Bike-Share-Navigate-Speedy-Success-
Case Study of a Bike Rental Service called Cyclistic. Tasked with analyzing past years bike sharing data to determine differences between Membership owning users and Casual Users.

Download dataset from https://divvy-tripdata.s3.amazonaws.com/index.html .

Data based on 'Sophisticated, Clear, and Polished': Divvy and Data Visualization written by Kevin Hartman.

Before starting analysis process in RStudio, first download the data and follow these steps using any spreadsheet tool:

1.Unzip the files.
2. Create a folder on your desktop or Drive to house the files. Use appropriate file-naming conventions.
3. Create subfolders for the .CSV file and the .XLS or Sheets file so that you have a copy of the original data. Move the
downloaded files to the appropriate subfolder.
4. Follow these instructions for either Excel (a) or Google Sheets (b):
  a. Launch Excel, open each file, and choose to Save As an Excel Workbook file. Put it in the subfolder you created
  for .XLS files.
  b. Open each .CSV file in Google Sheets and save it to the appropriate subfolder.
5. Open your spreadsheet and create a column called “ride_length.” Calculate the length of each ride by subtracting the
  column “started_at” from the column “ended_at” (for example, =D2-C2) and format as HH:MM:SS using Format > Cells >
  Time > 37:30:55.
6. Create a column called “day_of_week,” and calculate the day of the week that each ride started using the “WEEKDAY”
  command (for example, =WEEKDAY(C2,1)) in each file. Format as General or as a number with no decimals, noting that
  1 = Sunday and 7 = Saturday.
7. Proceed to the analyze step.
8. I have saved each file as <monthname>.csv (for example- jan.csv)
