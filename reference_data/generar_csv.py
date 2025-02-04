import pymupdf
import pandas as pd

doc_table = pymupdf.open("./Fukuda_2023_Tabla_predichos.pdf")
pagina = doc_table[0]
tablas = pagina.find_tables()
tabla = tablas[0]
a = 0
lista_cols = []
lista_tabla = tabla.extract()
encabezado = lista_tabla[1][1:]
tipos_datos = ("_Predicted(Gpa)", "_Reported(Gpa)", "_Error(%)")
for i, tok in enumerate(encabezado):
    check = i//4
    encabezado[i] = tok + tipos_datos[check]
#fin for

dic_datos = dict()
datos_tabla = lista_tabla[3:]

for i, dato in enumerate(datos_tabla):
    dic_datos[dato[0]] = dict(map(lambda x, y: (x, y), encabezado, dato[1:]))
#fin for 

tabla_datos = pd.DataFrame(dic_datos)
print(tabla_datos)
tabla_datos.to_csv("Datos_Fukuda.csv")
