# Dynamiek in beeld 

<!-- Include Github badges here (optional) -->
<!-- e.g. Github Actions workflow status -->

Application to be used in a clinical setting to understand empathy. The application allows clinician to conduct a survey and immediately visualize the results. No data is stored in the RShiny server. 

## Usage

<!-- We should add here -->
The app runs online at xxxx [link]

The app has three parts:

### Introduction
Basic description of the survey, and possibility to upload results from a participant.

(image goes here)

### Questionnaire
Five question, each with three subquestions. 

<img src="man/figures/screenshot_question.png" alt="Question and possible options" width="250px"/>

At the end of the questionnaire, the results of the survey can be downloaded.


### Visualization

(image goes here)




## Adapting the survey with new questions

If you would like to modify the app and run locally, please follow the following steps:


### Set up survey
- `data/introduction.csv` - Text in the introduction page, explaining the survey to the participant
- `data/situations.csv` - ID of the questions, description and attached figure (to be displayed in the left)
- `data/sub_situations.csv` - Each situation has two extra sub_situations
- `data/RadioMatrixFrame.csv` - Scales associated (see image above)


### Run code
- Install dependencies //renv information here//
- Run shiny app



<!-- ABOUT THE PROJECT -->
## About the Project

**Date**: October 2021

**Researcher(s)**:

- Minet de Wied (m.dewied@uu.nl)


**Research Software Engineer(s)**:

- Javier Garcia Bernardo (j.garciabernardo@uu.nl)

- Shiva Nadi Najafabadi(s.nadinajafabadi@uu.nl)

- Parisa Zahedi (p.zahedi@uu.nl)

### Built with

- [shiny1.7.1](https://shiny.rstudio.com)

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community an amazing place
to learn, inspire, and create. Any contributions you make are **greatly
appreciated**.

Please refer to the
[CONTRIBUTING](https://github.com/sodascience/osmenrich/blob/main/CONTRIBUTING.md)
file for more information on issues and pull requests.


<!-- Do not forget to also include the license in a separate file(LICENSE[.txt/.md]) and link it properly. -->
### License

The code in this project is released under [MIT license](LICENSE.md).

<!-- CONTACT -->

## Contact

This package is developed and maintained by the [ODISSEI Social Data
Science (SoDa)](https://odissei-data.nl/nl/soda/) team.

Do you have questions, suggestions, or remarks? File an issue in the
issue tracker or feel free to contact [Javier Garcia-Bernardo](https://github.com/jgarciab)
(:bird: [@jgarciab](<https://twitter.com/javiergb_com>)) or [Parisa 
Zahedi](https://github.com/parisa-zahedi)

<img src="man/resources/word_colour-l.png" alt="SoDa logo" width="250px"/> 

Project Link: [https://github.com/sodascience/empathy-viz](https://github.com/sodascience/empathy-viz)
