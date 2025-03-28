#set text(font: "UbuntuMono Nerd Font")
#set par(justify: true) 
== Resolución del problema inverso de RUS (Espectroscopía de Resonancia Ultrasónica) en el caso cubico

== Alejandro Cubillos
=== Estudiante de maestría, Departamento de Física, Universidad de los Andes

En el seminario se describirá brevemente en qué consiste la técnica de RUS y cómo esta permite obtener las frecuencias de resonancia de un sólido, para luego determinar sus constantes elásticas. Estas constantes elásticas son de fundamental importancia debido a que están relacionadas directamente a la estructura atómica y diferentes propiedades térmicas del material #cite(<Leisure_1997>). Estas frecuencias están relacionadas con las constantes elásticas mediante un problema de valores propios generalizado, en el cual las frecuencias están dentro de los valores propios. Sin embargo, en el laboratorio se obtienen las frecuencias de resonancia y hay que encontrar las constantes elásticas a partir de estas frecuencias. Existe un método que permite resolver este problema llamado el algoritmo de Levenber-Marquardt, el cual determina las constantes de manera iterativa, cuyo éxito depende de una buena inicialización de las constantes y puede ser lento debido a la cantidad de iteraciones que puede llegar a hacer #cite(<Fukuda_2023>). Por estas razones se buscó entrenar un modelo de machine learning que permita obtener las constantes elásticas a partir de las frecuencias de resonancia en una sola iteración, el cual fue entrenado con múltiples datos, provenientes de las resolución del problema de valores propios. En el presente seminario se describirá cómo se entrenó dicho modelo y cómo fue su desempeño obteniendo las constantes elásticas de distintos materiales, con diferentes estructuras cristalinas. 

#bibliography("References.bib")
