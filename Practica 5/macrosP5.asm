;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  IMPRIMIR TEXTO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print macro cadena
mov ah,09h
mov dx, offset cadena
int 21h
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%    OBTENER FECHA Y HORA     %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ObtenerFechaHora macro bufferFecha
PUSH ax
PUSH bx
PUSH cx
PUSH dx
PUSH si
	xor si, si
	xor bx, bx

	mov ah,2ah
	int 21h
	;REGISTRO DL = DIA 	 REGISTRO DH = MES

	Establer_Numero bufferFecha, dl  		;ESTABLECIENDO UN NUMERO PARA DIA
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	Establer_Numero bufferFecha, dh 		;ESTABLECIENDO UN NUMERO PARA MES
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	mov bufferFecha[si],31h	; = 1
	inc si
	mov bufferFecha[si],39h	; = 9
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si

	mov ah,2ch
	int 21h
	;REGISTRO CH = HORA 	 REGISTRO CL = MINUTOS
	Establer_Numero bufferFecha, ch  		;ESTABLECIENDO UN NUMERO PARA HORA
	mov bufferFecha[si],3ah 				;HEXA DE :
	inc si
	Establer_Numero bufferFecha, cl 		;ESTABLECIENDO UN NUMERO PARA MINUTOS

POP si
POP dx
POP cx
POP bx
POP ax
endm

Establer_Numero macro bufferFecha, registro
PUSH ax
PUSH bx
	xor ax,ax
	xor bx,bx	;PASO MI REGISTRO PARA DIVIDIR
	mov bl,0ah
	mov al,registro
	div bl

	 Obtener_Numero bufferFecha, al 	;PRIMERO EL CONCIENTE
	 Obtener_Numero bufferFecha, ah 	;SEGUNDO EL MODULO

POP bx
POP ax
endm

Obtener_Numero macro bufferFecha, registro
LOCAL cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,Salir
	cmp registro , 00h
	je cero
	cmp registro, 01h
	je uno
	cmp registro, 02h
	je dos
	cmp registro, 03h
	je tres
	cmp registro, 04h
	je cuatro
	cmp registro, 05h
	je cinco
	cmp registro, 06h
	je seis
	cmp registro, 07h
	je siete
	cmp registro, 08h
	je ocho
	cmp registro, 09h
	je nueve
	jmp Salir

	cero:
		mov bufferFecha[si],30h 	;0
		inc si
		jmp Salir
	uno:
		mov bufferFecha[si],31h 	;1
		inc si
		jmp Salir
	dos:
		mov bufferFecha[si],32h 	;2
		inc si
		jmp Salir
	tres:
		mov bufferFecha[si],33h 	;3
		inc si
		jmp Salir
	cuatro:
		mov bufferFecha[si],34h 	;4
		inc si
		jmp Salir
	cinco:
		mov bufferFecha[si],35h 	;5
		inc si
		jmp Salir
	seis:
		mov bufferFecha[si],36h 	;6
		inc si
		jmp Salir
	siete:
		mov bufferFecha[si],37h 	;7
		inc si
		jmp Salir
	ocho:
		mov bufferFecha[si],38h 	;8
		inc si
		jmp Salir
	nueve:
		mov bufferFecha[si],39h 	;9
		inc si
		jmp Salir
	Salir:
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPARAR STRINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Comparar macro String1, String2
	LOCAL ContinuarLoop, InicioLoop, FinLoop, Contadores, NoIguales, Final
	xor si,si
	mov cx,4
	InicioLoop:	
	mov al, String1[si]
	mov dl, String2[si]
	cmp String1[si],24h
	je FinLoop
	cmp String2[si],24h
	je FinLoop
	cmp al,dl
	jne NoIguales
	cmp al,dl
	je ContinuarLoop
	jmp FinLoop
	ContinuarLoop:
	inc si
	dec cx
	cmp cx,0001b
    ja InicioLoop
	jmp FinLoop
	FinLoop:
	cmp al,dl
	jmp Final

	NoIguales:
	mov al,0
	mov dl,1
	cmp al,dl

	Final:
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR PANTALLA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear_Screen macro
	mov ax,03h
    int 10h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LimpiarBuffer macro buffer, NoBytes, Char
	LOCAL Repetir
	xor si,si
	xor cx,cx
	mov cx,NoBytes
	Repetir:
	mov buffer[si], Char
	inc si
	loop Repetir
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%% OBTNER UN CARACTER DEL TECLADO CON ECHO %%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getChar macro
	mov ah,01h
	int 21h
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%% OBTENER UN CARACTER DEL TECLADO SIN ECHO %%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getCharSE macro
	mov ah,08h
	int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TEXTO DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerTexto macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,24h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER RUTA DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerRuta macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,00h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ABRIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AbrirArchivo macro buffer, handler
mov ah,3dh
mov al,02h
lea dx,buffer
int 21h
jc Error_Abrir
mov handler,ax
jmp Exito_Abrir
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CERRAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CerrarArchivo macro handler
mov ah,3eh
mov bx, handler
int 21h
jc Error_Cerrar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% LEER ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LeerArchivo macro handler, buffer, NoBytes
mov ah,3fh
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Leer
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CREAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CrearArchivo macro buffer, handler
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
jc Error_Crear
mov handler,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ESCRIBIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EscribirArchivo macro handler, buffer, NoBytes
mov ah,40h
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Escritura
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR ASCII A NUMERO %%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConvertirAscii macro numero
LOCAL INICIO, FIN
xor ax,ax
xor bx,bx
xor cx,cx
mov bx,10
xor si,si
INICIO:
	mov cl,numero[si]
	cmp cl,48
	jl FIN
	cmp cl,57
	jg FIN
	inc si
	sub cl,48
	mul bx
	add ax,cx
	jmp INICIO
FIN:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR NUMERO A ASCII %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConvertirString macro buffer
LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN
LimpiarBuffer buffer, SIZEOF buffer, 24h
xor si,si
xor cx,cx
xor bx,bx
xor dx,dx
mov dl,0ah
test ax,1000000000000000	
jnz NEGATIVO
jmp Dividir2

NEGATIVO:
	neg ax
	mov buffer[si],45
	inc si
	jmp Dividir2
Dividir:
	xor ah,ah
Dividir2:
	div dl
	inc cx
	push ax
	cmp al,00h
	je FinCr3
	jmp Dividir
FinCr3:
	pop ax
	add ah,30h
	mov buffer[si],ah
	inc si
	loop FinCr3
	mov ah,24h
	mov buffer[si],ah
	inc si
FIN:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER NUMERO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getNumero macro buffer
LOCAL INICIO, FIN
xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h	
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INICIAR MODO VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InicioVideo macro
mov ax,0013h
int 10h
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIBUJAR UN PIXEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pixel macro x0, y0, color
push cx
mov ah,0ch
mov al,color
mov bh,0h
mov dx,y0
mov cx,x0
int 10h
pop cx
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PINTAR EJES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PintarEjes macro
LOCAL ejeX, ejeY
mov cx,13eh
ejeX:
	Pixel cx,5fh,2eh
	loop ejeX
	mov cx,0c6h
ejey:
	Pixel 9fh,cx,2eh
	loop ejey
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% PAUSA PARA SALIR DE VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PausaSalir macro
mov ah,10h
int 16h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% REGRESAR A MODO TEXTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RegresarATexto macro
mov ax,0003h
int 10h	
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% ASIGNAR VALOR COEFICIENTE %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AsignarCoeficiente macro coeficiente
LOCAL AsignarCero, Asignar1P, Asignar1N, Asignar2P, Asignar2N, Asignar3P, Asignar3N, Asignar4P, Asignar4N, Asignar5P, Asignar5N, Asignar6P, Asignar6N, Asignar7P, Asignar7N, Asignar8P, Asignar8N, Asignar9P, Asignar9N, FinAsignacion
LimpiarBuffer Cin, SIZEOF Cin, 24h
ObtenerTexto Cin
Comparar Cin, varCero ;0
je AsignarCero
Comparar Cin, var1P;1
je Asignar1P
Comparar Cin, var1S ;1
je Asignar1P
Comparar Cin, var1N ;-1
je Asignar1N
Comparar Cin, var2P ;2
je Asignar2P
Comparar Cin, var2S ;2
je Asignar2P
Comparar Cin, var2N ;-2
je Asignar2N
Comparar Cin, var3P;3
je Asignar3P
Comparar Cin, var3S;3
je Asignar3P
Comparar Cin, var3N;-3
je Asignar3N
Comparar Cin, var4P;4
je Asignar4P
Comparar Cin, var4S;4
je Asignar4P
Comparar Cin, var4N;-4
je Asignar4N
Comparar Cin, var5P;5
je Asignar5P
Comparar Cin, var5S;5
je Asignar5P
Comparar Cin, var5N;-5
je Asignar5N
Comparar Cin, var6P;6
je Asignar6P
Comparar Cin, var6S;6
je Asignar6P
Comparar Cin, var6N;-6
je Asignar6N
Comparar Cin, var7P;7
je Asignar7P
Comparar Cin, var7S;7
je Asignar7P
Comparar Cin, var7N;7
je Asignar7N
Comparar Cin, var8P;8
je Asignar8P
Comparar Cin, var8S;8
je Asignar8P
Comparar Cin, var8N;-8
je Asignar8N
Comparar Cin, var9P;9
je Asignar9P
Comparar Cin, var9S;9
je Asignar9P
Comparar Cin, var9N;-9
je Asignar9N
LimpiarBuffer Cin, SIZEOF Cin, 24h
RepetirAsignacion

AsignarCero:
	mov coeficiente,0
	jmp FinAsignacion
Asignar1P:
	mov coeficiente,1
	jmp FinAsignacion
Asignar1N:
	mov coeficiente,1111111111111111b
	jmp FinAsignacion
Asignar2P:
	mov coeficiente,2
	jmp FinAsignacion
Asignar2N:
	mov coeficiente,1111111111111110b
	jmp FinAsignacion
Asignar3P:
	mov coeficiente,3
	jmp FinAsignacion
Asignar3N:
	mov coeficiente,1111111111111101b
	jmp FinAsignacion
Asignar4P:
	mov coeficiente,4
	jmp FinAsignacion
Asignar4N:
	mov coeficiente,1111111111111100b
	jmp FinAsignacion
Asignar5P:
	mov coeficiente,5
	jmp FinAsignacion
Asignar5N:
	mov coeficiente,1111111111111011b
	jmp FinAsignacion
Asignar6P:
	mov coeficiente,6
	jmp FinAsignacion
Asignar6N:
	mov coeficiente,1111111111111010b
	jmp FinAsignacion
Asignar7P:
	mov coeficiente,7
	jmp FinAsignacion
Asignar7N:
	mov coeficiente,1111111111111001b
	jmp FinAsignacion
Asignar8P:
	mov coeficiente,8
	jmp FinAsignacion
Asignar8N:
	mov coeficiente,1111111111111000b
	jmp FinAsignacion
Asignar9P:
	mov coeficiente,9
	jmp FinAsignacion
Asignar9N:
	mov coeficiente,1111111111110111b
	jmp FinAsignacion
FinAsignacion:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% REPETIR ASIGNACION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RepetirAsignacion macro
mov cx,PasoAsignacion
cmp cx,1
je Asignarx4
cmp cx,2
je Asignarx3
cmp cx,3
je Asignarx2
cmp cx,4
je Asignarx1
cmp cx,5
je Asignarx0
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%% IMPRIMIR FUNCION ORIGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PrintFX macro
LOCAL NoFX, FinPrintFX
mov cx,BanderaFX
cmp cx,0
je NoFX
print fx
print pA
mov ax, Coeficientex4
ConvertirString NumeroAux
print NumeroAux
print x4
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex3
ConvertirString NumeroAux
print NumeroAux
print x3
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex2
ConvertirString NumeroAux
print NumeroAux
print x2
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex1
ConvertirString NumeroAux
print NumeroAux
print x1
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex0
ConvertirString NumeroAux
print NumeroAux
print pC
print salto
jmp FinPrintFX
NoFX:
	print NoExisteFX
FinPrintFX:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CALCULAR f'(x) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CalcularDX macro
mov ax,Coeficientex4
mov bx,4
mul bx
mov CoeficienteDx3,ax
mov ax,Coeficientex3
mov bx,3
mul bx
mov CoeficienteDx2,ax
mov ax,Coeficientex2
mov bx,2
mul bx
mov CoeficienteDx1,ax
mov ax,Coeficientex1
mov CoeficienteDx0,ax
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% IMPRIMIR DERIVADA f'(x) %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PrintDX macro
LOCAL NoDX, FinPrintDX
mov cx,BanderaFX
cmp cx,0
je NoDX
CalcularDX
print fprima
print pA
mov ax, CoeficienteDx3
ConvertirString NumeroAux
print NumeroAux
print x3
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, CoeficienteDx2
ConvertirString NumeroAux
print NumeroAux
print x2
print pC
print espacio
print sigMas
print espacio
print pA
mov ax,CoeficienteDx1
ConvertirString NumeroAux
print NumeroAux
print x1
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, CoeficienteDx0
ConvertirString NumeroAux
print NumeroAux
print pC
print salto
jmp FinPrintDX
NoDX:
	print NoExisteFX
FinPrintDX:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPRIMIR INTEGRAL F(x) %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PrintIntX macro
LOCAL NoIntX, FinIntX
mov cx,BanderaFX
cmp cx,0
je NoIntX
print Fint
print pA
mov ax, Coeficientex4
ConvertirString NumeroAux
print NumeroAux
print sigDiv
print Num5
print x5
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex3
ConvertirString NumeroAux
print NumeroAux
print sigDiv
print Num4
print x4
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex2
ConvertirString NumeroAux
print NumeroAux
print sigDiv
print Num3
print x3
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex1
ConvertirString NumeroAux
print NumeroAux
print sigDiv
print Num2
print x2
print pC
print espacio
print sigMas
print espacio
print pA
mov ax, Coeficientex0
ConvertirString NumeroAux
print NumeroAux
print x1
print pC
print espacio
print sigMas
print espacio
print ConstC
print salto
jmp FinIntX
NoIntX:
	print NoExisteFX
FinIntX:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Separar Fecha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SepararFecha macro
LOCAL LlenarFecha, SalirSepararFecha
xor si,si
mov cx,0ah
LlenarFecha:
mov al,bufferFechaHora[si]
mov bufferDate[si],al
inc si
cmp si,cx
jb LlenarFecha
SalirSepararFecha:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Separar Hora %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SepararHora macro
LOCAL LlenarHora, SalirSepararHora
mov si,0ah
xor di,di
mov cx,0fh
LlenarHora:
mov al,bufferFechaHora[si]
mov bufferHour[di],al
inc si
inc di
cmp si,cx
jb LlenarHora
SalirSepararHora:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TAMAÑO DE UN STRING %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getSize macro buffer, Char, NoBytes
LOCAL Comparar, Aumentar, FinGetSize
xor si,si
Comparar:
cmp buffer[si],Char
jne Aumentar
jmp FinGetSize

Aumentar:
inc si
cmp si,NoBytes
jb Comparar


FinGetSize:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAR REPORTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GenerarReporte macro
LOCAL NoReporte, FinReporte
mov cx,BanderaFX
cmp cx,0
je NoReporte
CrearArchivo bufferReporte, handlerReporte	
ObtenerFechaHora bufferFechaHora
EscribirArchivo handlerReporte, EncabezadoReporte, SIZEOF EncabezadoReporte
EscribirArchivo handlerReporte, TReporte, SIZEOF TReporte
EscribirArchivo handlerReporte, TFecha, SIZEOF TFecha
SepararFecha
EscribirArchivo handlerReporte, bufferDate, SIZEOF bufferDate
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
EscribirArchivo handlerReporte, THora, SIZEOF THora
SepararHora
EscribirArchivo handlerReporte, bufferHour, SIZEOF bufferHour
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
;-------------------- FUNCION ORIGINAL -------------------------
EscribirArchivo handlerReporte, TOriginal, SIZEOF TOriginal
EscribirArchivo handlerReporte, Rfx, SIZEOF Rfx
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex4
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx4, SIZEOF Rx4
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex3
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx3, SIZEOF Rx3
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex2
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx2, SIZEOF Rx2
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex1
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx1, SIZEOF Rx1
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex0
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
;--------------------- FUNCION DERIVADA ---------------------
EscribirArchivo handlerReporte, TDerivada, SIZEOF TDerivada
CalcularDX
EscribirArchivo handlerReporte, Rfprima, SIZEOF Rfprima
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, CoeficienteDx3
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx3, SIZEOF Rx3
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, CoeficienteDx2
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx2, SIZEOF Rx2
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, CoeficienteDx1
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx1, SIZEOF Rx1
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, CoeficienteDx0
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
EscribirArchivo handlerReporte, RSalto, SIZEOF RSalto
;---------------------- FUNCION INTEGRAL -------------------
EscribirArchivo handlerReporte, TIntegral, SIZEOF TIntegral
EscribirArchivo handlerReporte, RFint, SIZEOF RFint
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex4
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RsigDiv, SIZEOF RsigDiv
EscribirArchivo handlerReporte, RNum5, SIZEOF RNum5
EscribirArchivo handlerReporte, Rx5, SIZEOF Rx5
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex3
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RsigDiv, SIZEOF RsigDiv
EscribirArchivo handlerReporte, RNum4, SIZEOF RNum4
EscribirArchivo handlerReporte, Rx4, SIZEOF Rx4
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex2
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RsigDiv, SIZEOF RsigDiv
EscribirArchivo handlerReporte, RNum3, SIZEOF RNum3
EscribirArchivo handlerReporte, Rx3, SIZEOF Rx3
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex1
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, RsigDiv, SIZEOF RsigDiv
EscribirArchivo handlerReporte, RNum2, SIZEOF RNum2
EscribirArchivo handlerReporte, Rx2, SIZEOF Rx2
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RpA, SIZEOF RpA
mov ax, Coeficientex0
ConvertirString Num
getSize Num, 24h, SIZEOF Num
mov NBytes, si
EscribirArchivo handlerReporte, Num, NBytes
EscribirArchivo handlerReporte, Rx1, SIZEOF Rx1
EscribirArchivo handlerReporte, RpC, SIZEOF RpC
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RsigMas, SIZEOF RsigMas
EscribirArchivo handlerReporte, Respacio, SIZEOF Respacio
EscribirArchivo handlerReporte, RConstC, SIZEOF RConstC
CerrarArchivo handlerReporte
print ReporteGenerado
jmp FinReporte
NoReporte:
	print NoExisteFX
FinReporte:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASIGNAR INTERVALOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AsignarIntervalos macro
LOCAL AsignarMinimo, AsignarMaximo, AsignacionExitosa, InicioAsignacion
InicioAsignacion:
clear_Screen
print intervalo_titulo
print salto
print ingrese_inicial
AsignarMinimo:
ValorIntervalo ValorMinimo
print salto
print ingrese_final
AsignarMaximo:
ValorIntervalo ValorMaximo
mov ax,ValorMinimo
mov dx,ValorMaximo
cmp ax,dx
jl AsignacionExitosa
print salto
print int_invalido
getCharSE
jmp InicioAsignacion
AsignacionExitosa:
print salto
print asigTerminada
getCharSE
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CopiarArreglo macro BufferFuente, BufferDestino, Start, Finish
LOCAL Copiar
LimpiarBuffer BufferDestino, SIZEOF BufferDestino,24h
mov si, Start
mov cx,Finish
xor di,di
Copiar:
mov al,BufferFuente[si]
mov BufferDestino[di],al
inc si
inc di
cmp si,cx
jb Copiar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASIGNAR INTERVALO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ValorIntervalo macro intervalo
LOCAL InicioValor, PositivoConSigno, Negativo, SinSigno, FinAsignacion
InicioValor:
LimpiarBuffer Cin2, SIZEOF Cin2, 24h
getNumero Cin2
xor si,si
mov al,Cin2[si]
cmp al,2bh
je PositivoConSigno
cmp al,2dh
je Negativo
jmp SinSigno
PositivoConSigno:
	CopiarArreglo Cin2, CAux, 1, SIZEOF Cin2
	ConvertirAscii CAux
	cmp ax,64h
	jae InicioValor
	mov intervalo,ax
	jmp FinAsignacion
Negativo:
	CopiarArreglo Cin2, CAux, 1, SIZEOF Cin2
	ConvertirAscii CAux
	NOT ax
    add ax,00000001b
	cmp ax,1111111110011100b
	jle InicioValor
	mov intervalo,ax
	jmp FinAsignacion
SinSigno:
	ConvertirAscii Cin2
	cmp ax,64h
	jae InicioValor	
	mov intervalo,ax
FinAsignacion:
endm