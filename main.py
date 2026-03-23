# main.py - GIA 2.0 adaptado para Termux (modo texto estable)
import os
import random
import json
import threading
import time
import requests

# --- Configuración ---
datos_gia = {"memoria": [], "preferencias": {}}

# --- Funciones de "voz" adaptadas a texto ---
def hablar(texto):
    print(f"(GIA dice): {texto}")

# --- Funciones IA simuladas ---
def saludo():
    mensaje = "Ben día mi señor Anthony 😎 Soy GIA, tu asistente avanzada lista para ayudarte."
    print(mensaje)
    hablar(mensaje)

def ia_responder(pregunta):
    respuestas = [
        "Interesante, mi señor.",
        "Analizando información...",
        "Listo, ejecutado.",
        "Comprendido."
    ]
    return random.choice(respuestas)

def guardar_memoria(evento):
    datos_gia["memoria"].append(evento)
    try:
        with open("memoria_gia.json", "w") as f:
            json.dump(datos_gia, f)
    except Exception as e:
        print(f"Error al guardar memoria: {e}")

# --- Funciones principales ---
def conversar():
    print("\nComienza a conversar con GIA. Escribe 'salir' para volver al menú.")
    while True:
        mensaje = input("Tú: ")
        if mensaje.lower() == "salir":
            break
        respuesta = ia_responder(mensaje)
        print(f"GIA: {respuesta}")
        guardar_memoria({"tipo": "conversacion", "mensaje": mensaje, "respuesta": respuesta})

def traducir_texto():
    texto = input("Ingresa el texto a traducir: ")
    url = f"https://api.mymemory.translated.net/get?q={texto}&langpair=en|es"
    try:
        r = requests.get(url).json()
        traduccion = r['responseData']['translatedText']
        print(f"Traducción: {traduccion}")
        guardar_memoria({"tipo":"traduccion","original":texto,"traducido":traduccion})
    except Exception as e:
        print(f"Error en traducción: {e}")

def comandos_especiales():
    print("\n--- Comandos Especiales ---")
    print("a. Mostrar información del sistema")
    print("b. Crear carpeta en el teléfono")
    print("c. Abrir app (simulación)")
    print("d. Volver al menú principal")
    
    comando = input("Elige un comando: ").lower()

    if comando == "a":
        info = f"Sistema operativo: {os.name}, Ruta actual: {os.getcwd()}"
        print(info)
        guardar_memoria({"tipo": "info_sistema", "info": info})

    elif comando == "b":
        nombre_carpeta = input("Nombre de la carpeta a crear: ")
        ruta = os.path.join(os.getcwd(), nombre_carpeta)
        try:
            os.makedirs(ruta, exist_ok=True)
            mensaje = f"Carpeta '{nombre_carpeta}' creada en {os.getcwd()}"
            print(mensaje)
            guardar_memoria({"tipo": "carpeta", "ruta": ruta})
        except Exception as e:
            print(f"Error al crear carpeta: {e}")

    elif comando == "c":
        app = input("Nombre de la app a abrir (simulación): ")
        mensaje = f"Simulación: intentando abrir '{app}'…"
        print(mensaje)
        guardar_memoria({"tipo": "simulacion_app", "app": app})

    elif comando == "d":
        return

    else:
        print("Comando no reconocido.")

def modo_aprendizaje():
    print("\nGIA está aprendiendo...")
    guardar_memoria({"tipo": "aprendizaje", "detalle": "actualizacion automatica"})

def agente_autonomo():
    print("\nAgente autónomo activo: monitoreo en segundo plano.")
    def fondo():
        while True:
            time.sleep(60)
            guardar_memoria({"tipo": "fondo", "evento": "sincronizacion nube"})
    thread = threading.Thread(target=fondo, daemon=True)
    thread.start()

# --- Menú principal ---
def menu_principal():
    print("\n1. Conversar")
    print("2. Traducir")
    print("3. Comandos")
    print("4. Aprender")
    print("5. Agente")
    print("6. Salir")
    opcion = input("Opción: ")
    return opcion

# --- Main loop ---
def main():
    saludo()
    agente_autonomo()
    while True:
        opcion = menu_principal()
        if opcion == "1":
            conversar()
        elif opcion == "2":
            traducir_texto()
        elif opcion == "3":
            comandos_especiales()
        elif opcion == "4":
            modo_aprendizaje()
        elif opcion == "5":
            print("Modo agente activo. Monitoreando tareas en segundo plano...")
        elif opcion == "6":
            print("Adiós, mi señor Anthony 😎")
            break
        else:
            print("Opción no válida. Intenta de nuevo.")

if __name__ == "__main__":
    main()
