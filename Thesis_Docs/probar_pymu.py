import pymupdf

documento = pymupdf.open("Fukuda_2023.pdf")
cont_paginas = []
for pagina in documento:
    texto = pagina.get_text().encode("utf8")
    cont_paginas.append(texto)
#fin for
print(cont_paginas[1])
