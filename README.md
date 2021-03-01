## Data Wrangling and Graphing in R

One of the objectives of my data science boot camp was to take data provided to me and answer questions posed by the instructor using it.  This project was broken into two parts.  Part one dealt principally with data wrangling, while part two revolved around creating specialized graphs using the ggplot function within R.  Here I present this project for you as a demonstration of my knowledge of performing these tasks within R.  I will briefly introduce the two parts of my project and then provide a link to the R-Markdown file where you can see my work as well as the resulting plots. 

The data provided consists of 5 columns I will give a brief introduction of here:

| Field         | Description                                                  |
| :------------ | :----------------------------------------------------------- |
| attemptdate   | Date and Time of event                                       |
| attemptresult | LOGIN, LOGOUT, TIMEOUT, or SYSLOGOUT                         |
| userid        | The user triggering the event                                |
| type          | User type, i.e., AUTHORIZED                                  |
| maxsessionuid | Unique identifer for a session. This will show up from LOGIN to LOGOUT, TIMEOUT, or SYSLOGOUT. |

## Part One

The first part of this project includes demonstrating abilities with basic functions as well as more specialized functions in order to answer 3 different questions. The first question asks how many unique users are featured in the data.  The second question asks how many unique users are in each unique type of user. The third question of part one asks what the average session time for each unique user type is. 

## Part Two

Part two of the project gives the objective of creating a Gantt chart that shows blocks of time representing when each user logged in, mapped on the time field.  Calling also for the blocks representing each user to the colored by which user type they belong to.  In the process of making this happen I realized that there were far too many unique users to make this kind of a Gantt chart a feasible form of presentation.  While I did include a Gantt chart of this sort using a small sample of data, I also opted to present a better way to display this data.  That way being a time series chart showing the number of concurrent users per minute.

In the R-Markdown file located at https://michaeltruelsen.github.io/Data-Wrangling-and-Graphing-in-R/ I will breakdown these questions more and describe how I went from the raw data to the answers to each question.

The project files and their purpose are as follows:

Code.R is the R script containing all of the code used in this project.

Markdown.Rmd is the R-Markdown file that when knitted resulted in Markdown.html as well as the index file which is seen in the link above.

Project2Data.csv is the raw data that this project uses.

### Bibliography

This data was supplied to me by my instructor in my QuickStart data science bootcamp through Northeastern Illinois University.





