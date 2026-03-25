import os
import shutil
from variables import doc_types, img_types, software_types

def crear_carpetas(ruta):
    for carpeta in ['Documentos', 'Imagenes', 'Software', 'Otros']:
        ruta_carpeta = os.path.join(ruta, carpeta)
        if not os.path.exists(ruta_carpeta):
            os.makedirs(ruta_carpeta)

def mover_archivos(ruta):
    for archivo in os.listdir(ruta):
        ruta_archivo = os.path.join(ruta, archivo)
        if os.path.isfile(ruta_archivo):
            if archivo.endswith(doc_types):
                shutil.move(ruta_archivo, os.path.join(ruta, 'Documentos'))
            elif archivo.endswith(img_types):
                shutil.move(ruta_archivo, os.path.join(ruta, 'Imagenes'))
            elif archivo.endswith(software_types):
                shutil.move(ruta_archivo, os.path.join(ruta, 'Software'))
            else:
                shutil.move(ruta_archivo, os.path.join(ruta, 'Otros'))

def organizar_carpetas(ruta_base):
    crear_carpetas(ruta_base)
    mover_archivos(ruta_base)