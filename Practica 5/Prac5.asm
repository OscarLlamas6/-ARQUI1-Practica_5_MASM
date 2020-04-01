;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%       SINTAXIS MASM     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include macrosP5.asm	;Archivo con los macros a utilizar

.model small 
;********************** SEGMENTO DE PILA ***********************
.286
.stack 100h
;********************** SEGMENTO DE DATO ***********************
.data
;-----------------------------------------------------------------


CoeficienteDx0 WORD 0;
CoeficienteDx1 WORD 0;
CoeficienteDx2 WORD 0;
CoeficienteDx3 WORD 0;
NumeroAux db 100 dup('$')
Coeficientex0 WORD 0;
Coeficientex1 WORD 0;
Coeficientex2 WORD 0;
Coeficientex3 WORD 0;
Coeficientex4 WORD 0;
BanderaFX WORD 0;
PasoAsignacion WORD 0;
Numero1 db 100 dup('$')
Numero2 db 100 dup('$')
Resultado db 100 dup('$')
Num db 100 dup(00h)
NumPrint db 100 dup('$')
Cin db 3 dup('$')
varCero db 30h,"$$"
var1P db "1$$"
var1S db "+1$"
var1N db "-1$"
var2P db "2$$"
var2S db "+2$"
var2N db "-2$"
var3P db "3$$"
var3S db "+3$"
var3N db "-3$"
var4P db "4$$"
var4S db "+4$"
var4N db "-4$"
var5P db "5$$"
var5S db "+5$"
var5N db "-5$"
var6P db "6$$"
var6S db "+6$"
var6N db "-6$"
var7P db "7$$"
var7S db "+7$"
var7N db "-7$"
var8P db "8$$"
var8S db "+8$"
var8N db "-8$"
var9P db "9$$"
var9S db "+9$"
var9N db "-9$"
salto db " ",0ah,0dh,"$"
exitoAbrir db "ARCHIVO CARGADO EXITOSAMENTE!",0ah,0dh,"$"
exitoGuardar db "ARCHIVO GUARDADO EXITOSAMENTE!",0ah,0dh,"$"
errorCrear db "ERROR AL CREAR EL ARCHIVO!",0ah,0dh,"$"
errorAbrir db "ERROR AL CARGAR EL ARCHIVO!",0ah,0dh,"$"
errorCerrar db "ERROR AL CERRAR EL ARCHIVO!",0ah,0dh,"$"
errorLeer db "ERROR AL LEER EL ARCHIVO!",0ah,0dh,"$"
errorEscritura db "ERROR AL ESCRIBIR EL ARCHIVO!",0ah,0dh,"$"
encabezado db "	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",0ah,0dh,"	FACULTAD DE INGENIERIA",0ah,0dh,
				09h,"CIENCIAS Y SISTEMAS",0ah,0dh,"	ARQUITECTURAS DE COMPUTADORES Y ENSAMBLADORES 1",0ah,0dh,
				09h,"SECCION A",0ah,0dh,"	NOMBRE: OSCAR ALFREDO LLAMAS LEMUS",0ah,0dh,
				09h,"CARNET: 201602625",0ah,0dh,0ah,0dh,"$"
menu db "	1) Ingresar funcion f(x)",0ah,0dh,"	2) Funcion en memoria",0ah,0dh,"	3) Derivada f'(x)",0ah,0dh,
				"	4) Integral F(x)",0ah,0dh,"	5) Graficar Funciones",0ah,0dh,"	6) Reporte",0ah,0dh,
				"	7) Modo Calculadora",0ah,0dh,"	8) Salir",0ah,0dh,"$"
elegir db "Elija una opcion:","$"
asigTerminada db "  Asignacion de coeficientes terminada. Presione cualquier tecla para continuar.","$"
PresioneContinuar db "  Presione cualquier tecla para continuar.","$"
NoExisteFX db "  No se ha ingresado ninguna funcion f(x).",0ah,0dh,"$"
SiExisteFX db "  Si ha ingresado funcion f(x).",0ah,0dh,"$"
asignacion_titulo db "++++++++++++ ASIGNACION DE COEFICIENTES ++++++++++++",0ah,0dh,"$"
fx_titulo db "++++++++++++ Funcion original f(x) ++++++++++++",0ah,0dh,"$"
dx_titulo db "++++++++++++ Derivada f'(x) ++++++++++++",0ah,0dh,"$"
int_titulo db "++++++++++++ Integral F(x) ++++++++++++",0ah,0dh,"$"
Cx0 db "    - Coeficiente de x0: ","$"
Cx1 db "    - Coeficiente de x1: ","$"
Cx2 db "    - Coeficiente de x2: ","$"
Cx3 db "    - Coeficiente de x3: ","$"
Cx4 db "    - Coeficiente de x4: ","$"
fx db "  f(x) =  ","$"
fprima db "  f'(x) =  ","$"
Fint db "  F(x) =  ","$"
ConstC db "C","$"
sigMas db "+","$"
sigDiv db "/","$"
Num5 db "5","$"
Num4 db "4","$"
Num3 db "3","$"
Num2 db "2","$"
x5 db "*x^5","$"
x4 db "*x^4","$"
x3 db "*x^3","$"
x2 db "*x^2","$"
x1 db "*x","$"
pA db "(","$"
pC db ")","$"
espacio db "  ","$"
;********************** SEGMENTO DE CODIGO *********************** 
.code

main proc 
mov dx,@data
mov ds,dx

Inicio:
    Clear_Screen   	
	Imprimir_Encabezado:
	print encabezado
    print elegir
	print salto

Imprimir_Menu:
    print salto
	print menu
	getCharSE
	cmp al,31h			;1
	je OPCION1
	cmp al,32h			;2
    je OPCION2
    cmp al,33h			;3
    je OPCION3
    cmp al,34h			;4
    je OPCION4
    cmp al,35h			;5
    je OPCION5    
	cmp al,36h			;6
    je OPCION6
    cmp al,37h			;7
    je OPCION7
	cmp al,38h			;8
	je salir
	Clear_Screen
	jmp Inicio

OPCION1:
    Clear_Screen
    print asignacion_titulo
    print salto
    mov BanderaFX,0
    mov PasoAsignacion,1
    print Cx4
    Asignarx4:
    AsignarCoeficiente Coeficientex4
    inc PasoAsignacion
    print Cx3
    Asignarx3:
    AsignarCoeficiente Coeficientex3
    inc PasoAsignacion
    print Cx2
    Asignarx2:
    AsignarCoeficiente Coeficientex2
    inc PasoAsignacion
    print Cx1
    Asignarx1:
    AsignarCoeficiente Coeficientex1
    inc PasoAsignacion
    print Cx0
    Asignarx0:
    AsignarCoeficiente Coeficientex0
    mov BanderaFX,1
    print salto
    print asigTerminada
    getCharSE
	jmp Inicio

OPCION2:
    Clear_Screen
    print fx_titulo
    print salto
    PrintFX
    print salto
    print PresioneContinuar
    getCharSE
	jmp Inicio
        
OPCION3:
    Clear_Screen
    print dx_titulo
    print salto    
    PrintDX
    print salto
    print PresioneContinuar
    getCharSE	   
	jmp Inicio

OPCION4:	   
	Clear_Screen
    print int_titulo
    print salto
    PrintIntX
    print salto
    print PresioneContinuar
    getCharSE
	jmp Inicio

OPCION5:	   
	jmp salir

OPCION6:	   
	jmp salir

OPCION7:	   
	jmp salir

Exito_Abrir:
	print salto
	print exitoAbrir
	getCharSE
	jmp Inicio

Error_Crear:
	print salto
	print errorCrear
	getCharSE
	jmp Inicio

Error_Escritura:
	print salto
	print errorEscritura
	getCharSE
	jmp Inicio

Error_Abrir:
	print salto
	print errorAbrir
	getCharSE
	jmp Inicio

Error_Leer:
	print salto
	print errorLeer
	getCharSE
	jmp Inicio	

Error_Cerrar:
	print salto
	print errorCerrar
	getCharSE
	jmp Inicio

salir:					
	mov ax,4c00h 		
	xor al,al 
	int 21h 				

main endp 	

ConvertirNum proc
            push bp                    ;almacenamos el puntero base
            mov  bp,sp                 ;ebp contiene la direccion de esp
            sub  sp,2                  ;se guarda espacio para dos variables
            mov word ptr[bp-2],0       ;var local =0 
            pusha
            LimpiarBuffer Num, SIZEOF Num, 00h
            xor si,si                          ;si=0
            cmp ax,0                           ;si ax, ya viene con un cero
            je casoMinimo           
            mov  bx,0                          ;denota el fin de la cadena
            push bx                            ;se pone en la pila el fin de cadena
            Bucle:  
                mov dx,0
                cmp ax,0                    ;¿AX= 0?
                je toNum                    ;si:enviar numero al arreglo                
                mov bx,10                   ;divisor  = 10
                div bx                      ;ax =cociente ,dx= residuo
                add dx,48d                   ;residuo +48 para  poner el numero en ascii
                push dx                     ;lo metemos en la pila 
                jmp Bucle
            toNum:
                pop bx                      ;obtenemos elemento de la pila
                mov word ptr[bp-2],bx       ; pasamos de 16 bits a 8 bits 
                mov al, byte ptr[bp-2]
                cmp al,0                    ;¿Fin de Numero?
                je FIN                      ;si: enviar al fin del procedimiento
                mov num[si],al              ;ponemos el numero en ascii en la cadena
                inc si                      ;incrementamos los valores               
                jmp toNum                   ;iteramos de nuevo            
            casoMinimo:
                add al,48d                         ;convertimos 0 ascii
                mov Num[si],al                     ;Lo pasamos a num
                jmp FIN
            FIN:
                popa
                mov sp,bp               ;esp vuelve apuntar al inicio y elimina las variables locales
                pop bp                  ;restaura el valor del puntro base listo para el ret
                ret 
            ConvertirNum endp



ConvertirPrint proc
            push bp                   
            mov  bp,sp                
            sub  sp,2                 
            mov word ptr[bp-2],0      
            pusha
            LimpiarBuffer NumPrint, SIZEOF NumPrint, 24h
            xor si,si                        
            cmp ax,0                        
            je casoMinimo2         
            mov  bx,0                       
            push bx                          
            Bucle2:  
                mov dx,0
                cmp ax,0                   
                je toNum2                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp Bucle2
            toNum2:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je FIN2                  
                mov NumPrint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov NumPrint[si],al                
                jmp FIN2
            FIN2:
                popa
                mov sp,bp           
                pop bp                
                ret 
    ConvertirPrint endp

	


end main

