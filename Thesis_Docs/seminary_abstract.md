<h1> Resolución del problema inverso de RUS (Espectroscopía de Resonancia Ultrasónica) en el caso isotrópico </h1>

## Alejandro Cubillos
### Estudiante de maestría, Universidad de los Andes

Solución del problema inverso de la Espectroscopía de Resonancia Ultrasónica utilizando técnicas de aprendizaje automático para materiales isotrópicos

Exploramos cómo se determinan teóricamente las frecuencias de resonancia de un sólido isotrópico elástico dadas sus constantes elásticas, conocido como el problema directo o "forward problem". Este problema predice las frecuencias que se obtienen mediante la técnica experimental Espectroscopía de Resonancia Ultrasónica, RUS por sus siglas en inglés [1, 2]. Al obtener una cierta cantidad de frecuencias de resonancia es posible determinar las constantes elásticas, lo cual es la finalidad del RUS, mediante lo que se conoce como el problema inverso, que es considerablemente más complejo que el problema directo. Para resolver el problema inverso se ha propuesto usar modelos de aprendizaje automático que pueden infierir las constantes elásticas de un sólido isotrópico a partir de las frecuencias de resonancia obtenidas experimentalmente con RUS o generadas sintéticamente mediante la solución del problema directo. Además, se han propuesto distintas transformaciones a las variables de entrada (features) como a las de salida (targets) que permitan al modelo resolver el problema mas fácilmente, reduciendo la correlación entre variables de entrada (features). En este seminario se expondrá un modelo de red neuronal secuencial que podría resolver el problema inverso en el cas isotrópico. Encontrar las constantes elásticas de un sólido tiene aplicaciones importantes en la identificación de transiciones de fase electrónicas y estructurales en sólidos [3].


[1] R. G. Leisure and F. A. Willis. Resonant ultrasound spectroscopy. Journal of Physics: Condensed Matter, 9(28):6001, jul 1997
[2] A. Migliori, J. Sarrao, W. M. Visscher, T. Bell, M. Lei,Z. Fisk, and R. Leisure. Resonant ultrasound spectroscopic techniques for measurement of the elastic moduli of solids. Physica B: Condensed Matter, 183(1):1–24,1993
[3] F. Mouhat, F. X. Coudert. Necessary and Sufficient Stability Conditions in Variuous Crystal Systems. Phys. Rev. B, 90,224104, 2014  
