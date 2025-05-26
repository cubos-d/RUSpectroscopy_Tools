// global
#import "@preview/clean-math-thesis:0.3.0": template

//local
#import "customization/colors.typ": *

#set par(justify: true)
#show "Study Programme:": "" //Vaya solución cutre... pero por ahora funciona

#show: template.with(
  // personal/subject related stuff
  author: "\n Jose Alejandro Cubillos Muñoz",
  title: "A Machine Learning Approach to the Inverse Problem in Resonant Ultrasound Spectroscopy of Cubic and Isotropic Solids",
  supervisor1: "Prof. Julián Rincón, PhD.",
  supervisor2: "",
  degree: "Msc Physics",
  program: "",
  university: "Universidad de los Andes",
  institute: "Physics Department",
  city: "Bogotá D.C",
  deadline: datetime.today().display(),

  // file paths for logos etc.
  uni-logo: image("images/uniandes_logo.jpg", width: 25%),
  //institute-logo: image("images/physics_dep_logo.png", width: 50%),

  // formatting settings
  body-font: "UbuntuMono Nerd Font",
  cover-font: "UbuntuMono Nerd Font",
  // Anterior font: Libertinus Serif
  // chapters that need special placement
  abstract: include "chapter/abstract.typ",
  //Aquí supongo que van los agradecimientos
  // equation settings
  equate-settings: (breakable: true, sub-numbering: true, number-mode: "label"),
	equation-numbering-pattern: "(1.1)",

  // colors
  cover-color: color1,
  heading-color: color2,
  link-color: color3
)

// ------------------- content -------------------
#include "chapter/introduction.typ"
#include "chapter/chapter2.typ"
#include "chapter/chapter3.typ"
#include "chapter/chapter4.typ"
#include "chapter/chapter5.typ"
#include "chapter/chapter6.typ"
#include "chapter/conclusions_outlook.typ"
#include "chapter/appendix.typ"

// ------------------- bibliography -------------------
#bibliography("References.bib")

// ------------------- declaration -------------------
//#include "chapter/declaration.typ"
