# COVID 19 (2019-nCoV) Web Dashboard
This repo is created as part of a tutorial / workshop series intended to ease programming beginners into the world of Shiny web apps.

The lecture is divided into 5 parts and its intended audience are absolute beginners in Shiny and web development in general. 

## Preview
A preview of the app we're building:

[![App Preview](assets/apppreview.png)](https://youtu.be/BO3Ce_jZBts)

The final variant of your web app (`shiny_05`) reads updated data from [Novel Coronavirus (COVID-19) Cases, provided by JHU CSSE](https://github.com/CSSEGISandData/COVID-19) and offer the most up-to-date analytics on New Cases, Recovery and Deaths by country. 

- `app.R`: The code for your UI and Server
- `reader.R`: Read data from JHU CSSE github 
- `preprocess.R`: Clean and transform your data from a "wide" format to "long"
- `darker.R`: A custom ggplot2 theme I created for the sleek, modern, dark look

To keep the focus on the mechanics of Shiny, all of the data provided in this repo from variant 1 to varian 4 has been cleaned. Rather than spending 2 hours cleaning and reshaping data, you can invest that 2 hours into learning the features of Shiny. Variant 5 doesn't read from a static CSV file, but directly from the web source to ensure the most up-to-date data.

## Learn more about Shiny
1. Fork the [DarkerShiny](https://github.com/onlyphantom/darkershiny) template and work your data into the darker template
2. Attend a workshop on this topic (_more details coming soon_)
3. [Cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf) from RStudio

## Dataset Source
1. [canghailan/Wuhan-2019-nCoV](https://github.com/canghailan/Wuhan-2019-nCoV)
2. [Novel Coronavirus (COVID-19) Cases, provided by JHU CSSE](https://github.com/CSSEGISandData/COVID-19)

To use real-time data on the Corona virus epidemic, read from the end points below:
- csv: https://raw.githubusercontent.com/canghailan/Wuhan-2019-nCoV/master/Wuhan-2019-nCoV.csv
- json: https://raw.githubusercontent.com/canghailan/Wuhan-2019-nCoV/master/Wuhan-2019-nCoV.json
