unit UnidadClinica;

interface

uses SysUtils;

const
  MAX_ARRAY = 2000; // Maximo de pacientes en total
  RUTA_PACIENTES = '.\Archivos\tpacientes.txt';
  RUTA_HISTORIAL_PACIENTES = '.\Archivos\Pacientes';

type

  rIngreso = record
    dia: byte;
    mes: byte;
    anio: integer;
  end;

  rPaciente = record
    nombre: string[51];
    apellidos: string[51];
    edad: byte;
    sexo: char; // caracter h / m de hombre o mujer
    ingreso: rIngreso;
    codigoHistorial: string[10]; // 9 letras aleatorias
    tieneSeguro: boolean;
    totalFacturado: integer; // esperemos que no sea tan grande
  end;

  tTopeArray = 0..MAX_ARRAY;

  tArray = array[0..MAX_ARRAY - 1] of rPaciente; // max 2000 pacientes

  tArrayPacientes = record
    pacientes: tArray;
    tope: tTopeArray;
  end;


procedure Menu();
procedure Submenu();

procedure MostrarHistorialClinico(codigo: string; RUTAHISTORIALPACIENTES: string);
procedure EscribirHistorialClinico(codigo, texto: string;
  RUTAHISTORIALPACIENTES: string);


procedure CargarDatos(var arrPacientes: tArrayPacientes; var ficheroPacientes: Text);
// punto 1
procedure AddPaciente(var arrPacientes: tArrayPacientes; pacienteNuevo: rPaciente;
  RUTAHISTORIALPACIENTES: string);
// punto 2
procedure MostrarPacientes(var arrPacientes: tArrayPacientes);
// punto 3
procedure MostrarPacientesSeguro(var arrPacientes: tArrayPacientes);
// punto 4
procedure BuscarPacienteCodigo(var arrPacientes: tArrayPacientes; codigo: string);
// punto 5
function MostrarTotalFacturado(var arrPacientes: tArrayPacientes): integer;
// punto 6
procedure Guardar(var arrPacientes: tArrayPacientes; var ficheroPacientes: Text);
// punto 7

// pongo VAR en cada array porque pueden llegar a ser bastante grandes y asi no se copia todo el array ( eficiente con la memoria )

implementation

procedure Menu();
begin
  writeln('Elija una opcion:');
  writeln('-------------------------');
  writeln('1 - Cargar un archivo .txt');
  writeln('2 - Aniadir un nuevo paciente');
  writeln('3 - Listar todos los pacientes');
  writeln('4 - Mostrar pacientes con seguro medico');
  writeln('5 - Buscar paciente por numero de historia clinica');
  writeln('6 - Mostrar total facturado');
  writeln('7 - Guardar y salir');
end;

procedure Submenu(); // para el punto 3
var
  subopcion:byte;
  codigo:string;
begin
  repeat

  writeln('Que deseas hacer ahora? Elija una opcion: ');
  writeln('-------------------------');
  writeln('1. Ver historial clinico de un paciente');
  writeln('2. Agregar entrada al historial del paciente');
  writeln('3. Volver atras.');

  readln(subopcion);

    case subopcion of
      1: begin
        Write('Escriba el codigo del paciente en MAYUSCULAS (porfis) -> ');
        readln(codigo);
        MostrarHistorialClinico(codigo,
          RUTA_HISTORIAL_PACIENTES);
      end;
      2: begin
        Write('Escriba el codigo del paciente en MAYUSCULAS (porfis) -> ');
        readln(codigo);

        Write('Escriba el texto que quiere aniadir al historial -> ');
        readln(texto);

        EscribirHistorialClinico(codigo, texto, RUTA_HISTORIAL_PACIENTES);

      end;
      3: writeln('Volviendo al menu principal...');

      else
        writeln('Opcion incorrecta!');
    end;

    writeln();
  until subopcion = 3;
end;

procedure MostrarHistorialClinico(codigo, RUTAHISTORIALPACIENTES: string);
var
  fichero: Text;
  texto: string;
begin
  Assign(fichero, RUTAHISTORIALPACIENTES + '\' + codigo + '.txt');
  // como pueden ser muchos archivos no puedo hacer esto en el programa principal, como con el otro archivo

  {$I-}
  reset(fichero);
  {$I+}

  if (IORESULT <> 0) then
  begin
    writeln('Tal paciente no existe! ( Algun error ha pasado )');
    // puede que nop exista el paciente o el archivo ( esperemos que el paciente )
  end
  else
  begin
    while (not EOF(fichero)) do
    begin
      readln(fichero, texto);
      writeln(texto);
    end;

    Close(fichero);
  end;

end;

procedure EscribirHistorialClinico(codigo, texto: string;
  RUTAHISTORIALPACIENTES: string);
var
  fichero: Text;
begin
  Assign(fichero, RUTAHISTORIALPACIENTES + '\' + codigo + '.txt');

  {$I-}
  append(fichero);
  {$I+}

  if (IORESULT <> 0) then
  begin
    writeln('Tal paciente no existe! ( Algun error ha pasado )');
  end
  else
  begin
    writeln(fichero, texto);

    Close(fichero);

    writeln('Texto escrito en el historial!');
  end;

end;

procedure CargarDatos(var arrPacientes: tArrayPacientes; var ficheroPacientes: Text);
// punto 1
var
  i: integer;
  pacienteNuevo: rPaciente;
  texto: string;
begin

  {$I-}
  reset(ficheroPacientes);
  {$I+}

  if (IORESULT <> 0) then
  begin
    writeln('El archivo no existe! ( Algun error ha pasado )');
  end
  else
  begin
    i := 0;

    while (i < MAX_ARRAY) and (not EOF(ficheroPacientes)) do
    begin
      Readln(ficheroPacientes, texto);

      pacienteNuevo.nombre := copy(texto, 1, pos(' ', texto) - 1);
      Delete(texto, 1, pos(' ', texto));

      pacienteNuevo.apellidos := copy(texto, 1, pos('|', texto) - 1);
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.edad := StrToInt(copy(texto, 1, pos('|', texto) - 1));
      Delete(texto, 1, pos('|', texto));

      if (copy(texto, 1, pos('|', texto) - 1) = 'h') then
        pacienteNuevo.sexo := 'h'
      else
        pacienteNuevo.sexo := 'm';
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.codigoHistorial := copy(texto, 1, pos('|', texto) - 1);
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.ingreso.dia := StrToInt(copy(texto, 1, pos('|', texto) - 1));
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.ingreso.mes := StrToInt(copy(texto, 1, pos('|', texto) - 1));
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.ingreso.anio := StrToInt(copy(texto, 1, pos('|', texto) - 1));
      Delete(texto, 1, pos('|', texto));

      if (copy(texto, 1, pos('|', texto) - 1) = 'TRUE') then
        pacienteNuevo.tieneSeguro := True
      else
        pacienteNuevo.tieneSeguro := False;

      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.totalFacturado := StrToInt(texto);

      arrPacientes.pacientes[i] := pacienteNuevo;

      // tremendo conazo con esto pero se hizo

      i := i + 1;

    end;

    if (i = MAX_ARRAY) and not EOF(ficheroPacientes) then
      writeln('Se ha alcanzado el tope del array, el resto de datos no se han cargado!');

    Close(ficheroPacientes);

    arrPacientes.tope := i;

    if (i = 0) then
      writeln('El archivo esta vacio!');

    writeln('Pacientes cargados!');

  end;

end;

procedure AddPaciente(var arrPacientes: tArrayPacientes; pacienteNuevo: rPaciente;
  RUTAHISTORIALPACIENTES: string);
// punto 2
var
  fichero: Text;
  i, j: integer;

  procedure Swap(var a, b: rPaciente);
  var
    aux: rPaciente;
  begin
    aux := a;
    a := b;
    b := aux;
  end;

begin
  arrPacientes.pacientes[arrPacientes.tope] := pacienteNuevo;

  arrPacientes.tope := arrPacientes.tope + 1;

  Assign(fichero, RUTAHISTORIALPACIENTES + '\' + pacienteNuevo.codigoHistorial + '.txt');

  {$I-}
  rewrite(fichero);
  {$I+}

  if (IORESULT <> 0) then
  begin
    writeln('El archivo no se ha podido crear! ( Algun error ha pasado )');
  end
  else
  begin
    Close(fichero);
  end;

  for i := 0 to arrPacientes.tope - 2 do
    for j := 0 to arrPacientes.tope - 2 - i do
    begin

      if (arrPacientes.pacientes[j].nombre > arrPacientes.pacientes[j +
        1].nombre) or ((arrPacientes.pacientes[j].nombre =
        arrPacientes.pacientes[j + 1].nombre) and
        (arrPacientes.pacientes[j].apellidos =
        arrPacientes.pacientes[j + 1].apellidos)) then
      begin
        Swap(arrPacientes.pacientes[j], arrPacientes.pacientes[j + 1]);
      end;

    end;

  writeln('Paciente creado exitosamente!');

end;

procedure MostrarPacientes(var arrPacientes: tArrayPacientes); // punto 3
var
  i: integer;

  function MostrarFechaIngreso(ingreso: rIngreso): string;
  begin
    MostrarFechaIngreso := IntToStr(ingreso.dia) + '/' + IntToStr(ingreso.mes) +
      '/' + IntToStr(ingreso.anio); // devuelve un string
  end;

  function ConSeguro(tieneSeguro: boolean): string;
  begin
    if (tieneSeguro = True) then
      ConSeguro := ' con seguro medico,'
    else
      ConSeguro := ' sin seguro medico,';
  end;

  function QueSexo(sexo: char): string;
  begin
    if (sexo = 'h') then
      QueSexo := 'hombre'
    else
      QueSexo := 'mujer';
  end;

begin
  writeln('La lista de pacientes es:');
  writeln();

  for i := 0 to arrPacientes.tope - 1 do
  begin
    writeln(i + 1, '- Paciente ', arrPacientes.pacientes[i].nombre, ' ',
      arrPacientes.pacientes[i].apellidos, ', de genero ',
      QueSexo(arrPacientes.pacientes[i].sexo));

    writeln('con el codigo - ',
      arrPacientes.pacientes[i].codigoHistorial, ',');

    writeln('ingresado en la fecha ', MostrarFechaIngreso(
      arrPacientes.pacientes[i].ingreso), ',',
      ConSeguro(arrPacientes.pacientes[i].tieneSeguro));

    writeln('con el total facturado de ', arrPacientes.pacientes[i].totalFacturado,
      ' euros');

    writeln();
  end;

  SubMenu();

end;

procedure MostrarPacientesSeguro(var arrPacientes: tArrayPacientes); // punto 4
var
  i: integer;
  existePaciente: boolean;

  function MostrarFechaIngreso(ingreso: rIngreso): string;
  begin
    MostrarFechaIngreso := IntToStr(ingreso.dia) + '/' + IntToStr(ingreso.mes) +
      '/' + IntToStr(ingreso.anio); // devuelve un string
  end;

  function QueSexo(sexo: char): string;
  begin
    if (sexo = 'h') then
      QueSexo := 'hombre'
    else
      QueSexo := 'mujer';
  end;

begin
  writeln('La lista de pacientes con seguro medico es:');
  writeln();

  existePaciente := False; //  variable para saber si hay pacientes con seguro medico

  for i := 0 to arrPacientes.tope - 1 do
  begin
    if (arrPacientes.pacientes[i].tieneSeguro = True) then
    begin
      existePaciente := True; // Sabemos que existe al menos un paciente con seguro

      writeln('Paciente ', arrPacientes.pacientes[i].nombre, ' ',
        arrPacientes.pacientes[i].apellidos, ', de genero ',
        QueSexo(arrPacientes.pacientes[i].sexo));

      writeln('con el codigo - ',
        arrPacientes.pacientes[i].codigoHistorial, ',');

      writeln('ingresado en la fecha ', MostrarFechaIngreso(
        arrPacientes.pacientes[i].ingreso), ',');

      writeln('con el total facturado de ', arrPacientes.pacientes[i].totalFacturado,
        ' euros');

      writeln();
    end;
  end;

  if (existePaciente = False) then
    writeln('No hay pacientes asegurados!');

  // Se podria anadir un campo al array que cuente los pacientes asegurados y esta funcion seria un
  // if pacientes asegurados > 0 else con un for y el writeln de arriba para terminar mas rapido y no usar la "banderita"
end;

procedure BuscarPacienteCodigo(var arrPacientes: tArrayPacientes;
  codigo: string); // punto 5
var
  i: integer;
  encontrado: boolean;

  function MostrarFechaIngreso(ingreso: rIngreso): string;
  begin
    MostrarFechaIngreso := IntToStr(ingreso.dia) + '/' + IntToStr(ingreso.mes) +
      '/' + IntToStr(ingreso.anio); // devuelve un string
  end;

  function ConSeguro(tieneSeguro: boolean): string;
  begin
    if (tieneSeguro = True) then
      ConSeguro := ' con seguro medico,'
    else
      ConSeguro := ' sin seguro medico,';
  end;

  function QueSexo(sexo: char): string;
  begin
    if (sexo = 'h') then
      QueSexo := 'hombre'
    else
      QueSexo := 'mujer';
  end;

begin
  encontrado := False;
  i := 0;

  repeat
    if arrPacientes.pacientes[i].codigoHistorial = codigo then
      encontrado := True
    else
      i := i + 1;

  until (encontrado = True) or (i = arrPacientes.tope);

  if encontrado = False then
    writeln('Paciente no encontrado!')
  else
  begin
    writeln('Paciente ', arrPacientes.pacientes[i].nombre, ' ',
      arrPacientes.pacientes[i].apellidos, ', de genero ',
      QueSexo(arrPacientes.pacientes[i].sexo));

    writeln('con el codigo - ',
      arrPacientes.pacientes[i].codigoHistorial, ',');

    writeln('ingresado en la fecha ', MostrarFechaIngreso(
      arrPacientes.pacientes[i].ingreso), ',',
      ConSeguro(arrPacientes.pacientes[i].tieneSeguro));

    writeln('con el total facturado de ', arrPacientes.pacientes[i].totalFacturado,
      ' euros');

    writeln();
  end;

end;


function MostrarTotalFacturado(var arrPacientes: tArrayPacientes): integer; // punto 6
var
  i, facturadoPaciente: integer;
begin
  facturadoPaciente := 0;

  for i := 0 to arrPacientes.tope - 1 do
  begin
    facturadoPaciente := facturadoPaciente + arrPacientes.pacientes[i].totalFacturado;
  end;

  MostrarTotalFacturado := facturadoPaciente;

end;

procedure Guardar(var arrPacientes: tArrayPacientes; var ficheroPacientes: Text);
// punto 7
var
  i: integer;
begin

  {$-}
  rewrite(ficheroPacientes);
  {$+}
  if IORESULT <> 0 then
    writeln('No existe el archivo')
  else
    rewrite(ficheroPacientes);
  for i := 0 to arrPacientes.tope - 1 do
  begin

    Write(ficheroPacientes, arrPacientes.pacientes[i].nombre, ' ',
      arrPacientes.pacientes[i].apellidos);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].edad);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].sexo);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].codigoHistorial);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].ingreso.dia);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].ingreso.mes);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].ingreso.anio);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].tieneSeguro);
    Write(ficheroPacientes, '|', arrPacientes.pacientes[i].totalFacturado);
    writeln(ficheroPacientes);
  end;

  Close(ficheroPacientes);
end;

end.
{
 Gato

:::::::..:.::.::..  ..:;:.:;;:::::++:+++xxxXXx+++xXXXXx;+xXX$&$$$$XXX$&&&&&&&&$XXX$&&&&&&&$x++;++&
....::;;::..::.:;::...:;;;+xxx+;;+x+:;+$&&$Xx++xx+++xX&$xxxxxX$$&&XxxxxXXXX$&&&&&$XXXXxXXx+;;+x+;&
......:;+;;;::::+xxxxxX$$X$$$X+++xx++x$&&&$XXx++++++++$&$x++xX$$$Xx;;;:::::;;+xxx+;.::::...:+++:;&
::;;;;;;++xX$&&&&&&&&&&&$xx+xx+;++++xX$$XXXXXx+++;+++++XXx;;;+xxXXx+;;::::::::::;;;:.::;::::..:++&
&&&&&&&$$&&&&&&&&$$&&&$x;;;;+Xx++x+xX$$Xxxxxx+++;::;;;;;+x+;::;;+XXXx+++;::....:::::::..:::;++xx+&
&&&&&&&&&&&$Xxxxx++++xXx++++xX$$$$$$$Xxxxxx+;;::::;:;;;;;+++;:::;xXXx++xx+;:...:::::::::.;++++++;&
;+xX$$&&&Xx+;;;;++++;;xXx++xx$&&&&&$x+++++++;;;;:::::::;;;;;;;;;;++xxx++++;;:..::.::........:;;::$
+++;:::::::;;;:::;;;;;;+Xx+++xX$$$$XXx+++;;;;;;;;::::::;;;::::::;++xxxx++++;;::;;:.:..::.:::;;;..X
$$Xx;;::.:.::;;;;;;;;;;:;++;:;;+xxxxxx+;;;:;;+;;;;::;;;:;;;;;::.:;+xx++;;++;;;;;;;::;::::::++;:::X
&$Xx;:::.:;;;+++++;::::...:::;;+++++++;;;:::;++;++++++;::;;++;;::;;+++;;:;;+++++++++xx+::;++:.:::$
+XXx+::;:::;::::::.....:.:.:;;;;;:;;;;;;;::;;;;;;++;;;;;;;:;;;;;;::::;+;;;;++xxxxXXxxXXX;::.....:$
X$X++;;::;:...::.......::::;;;;;::::::::::::::::::::::::;;;::;;;;:..:;+;:::;;;;+xxxxxXX$$X+:....:$
&&$XXx++;;. ..::.......;++;;:;;;::::::::::........:::::::::::::;;;::::;+;:..:::;;;;;+++x$&&$x;:+X&
&$x+++;;;:.....:..:;+++++x+;::;;::::...:.:......::::::::...:::::::::::;+++::::::::::;;;+xX$$XxxxxX
Xx++;;:.....::;:::;+xXXx++++;;:::....:...:::::::::::::..:::..::::::::::;+x;::::::::;+++++++xXX$XXX
&x;;;:.........::;;;;;;;;;;;;;:::....:::::;;;::.......:::::.....::::::::;++::::::;++++++++;+x$&&&&
&&X+:...........:;++;:::;;;;::::.....:::::::::::..........:.............:;+;+++++++;:::;;;;;;;+xX&
&&$x:.........:;+++;;::....:::::....:;;;:....................:..........:;+xx++++;:::::;;;++++xxX&
&&&x;.......::;+++;::.......::;;;;;;;;;::...        ........:::..........:::..::;;;+xX$&&$X+;;+xx&
&&Xx:.......:;;;;:::........::::;;++++;::...             ...:::..:.......:+X&&&&&&&&&&&&&$x+;+X&&&
&Xx+:.......:;;;:.......::::::::::.........           ....  .::.......:;+X&&&&&&&&&$x::+X$$x+xX$X$
$x+;:.......:;:::.:;+xxX$&&&&&:x&&&&$$Xx+;:....      ........:::::..::;+$&&x::;X&&&&&&&&&&$x+x$&$$
$x+;::......:::;::;+x$&&&&&&&&&&&&&&&&&&&&x;:....  ........:;+;;;;;:.;+x$X:x&&&&&&&&&&$Xx++++x$&$&
X++;;::.....:::::::;++++xxXX+$&$:;::::;X&&&X;:......::::;;+xxxx++xXXx;xX+:x$$$$$x+;:;::::;;++xX&&&
x++;;;;:...:;;;;;++X$&&&&&&&&&&&&&&&&&&x:;$$X+::..:;;;;;++xxxxxxXXX$$Xx++X$X+++;;;::::::::;;++X$&&
Xx++;+++:...:;+;::::;++xX$&&&&&&&&&&&&&$Xx+++x+::;;;;;;;;;;;:::;++xxXX+.+xx+;;:..:::::..:;+++xX&&&
&&&Xx++x+:.:;;++:::::::;;++++++++++++xxX$&$X+:;::;:::::::::::::;;;::;++++;:::::...::....:;++xX$&&&
$&&&&x++x+::;;+;::::..:::::::......:::;++++++;:...:.....:::::::;+x+;.:;+x+;::::....:..::;+xxX$&&&&
;+x$$x+;+++;:;+;::::...................:::::::::.:::.....::...::;+++:.:;++;:::::::::.:;;+xxxX$&&$X
;;+X$Xx++++;;;;;::::......................::::::..:::::::::.....::;+;:.;++;::::::::::;+xXXXX$$$X+x
:;+X&&&$xxx+++++;;;;;;::.........    ........::..::;;;:::::.::....;;+;:+x+;:.:::..::+x$$&&&$$Xx;;x
..:;+X$$XXx+;;+xx++;;;;;:.....         .......::::;++;::.........:;+++;xXx;.......:;x$&&&&$XXXx++x
...:;+X$$Xx+::;;++++;;;;;;:........     .......:;;+++++;;:.......:;+++;$&x;;;::...:x$&&&&&&&&&$x++
::..:;+X&&$x;::::;+++++;;;;;:::::...         ..:;+xx++x+;:........;++x:$&$;:::::..:x$&&$;::;;;+xxX
;::::;++x$&X+:...::;++x++xxxx++;;:::.......  ...;xxx+;;++;:.   ..:+x+;x&&X;...::..:+$&&&x:;;:....x
:...;+;;+x$&$+:...:..:+xxXX$&&$Xx+;;;;:::.......;xX$$x+.;++:....:+Xx.X&&&+:....:..:;x$&&&XX$$$$$$X
;++++;::;x$&&&&&&Xx++;;;;;;+++xx+;::.::::.......:;x$&&$x;:;;:;;;+x+:$&&X+:.....::..:+X$&&$+::::;;;
...:;+xX&&&&&&&&&&&&$x+;;:....:;+;:.....:........::;xxxXx+.:;+;;;:;$&X+:....::.:::;;+X$&&$$XXx+;:;
XXX$$$XXXxxxxX$&Xx+xxxxx+;...:;;+;:::::::;:::......:;;++++;:;;;:.:x$X;:........:;;;;xX&&&+:::;++xx
......   ..::+xXx+;;;;::;+xx+;;+++;::...::::::......:;;;;++;;;::;+x+;:::::::..:;+++x&&&&$xx+;:..:x
:.       ..:;xX$&$X+;:..:++++;;xxx+;:.....:::::...:::;;;;;+++;:;;;;+x+;;;;;;;;;+xxX&&&&&x::::++x+x
:.      .:+$&&&&$;:;;:....::::+X$$Xx+;;;;;;;;;;;:;;;;+++++xxXxxx++;;++++++++++xxX$&&&&X+;::::::.:+
:: ...:+$&&&Xx++x+;::::::::.:;;+X$&&$X++;;;;;;;;;;++++++;;+x+::++;::;+X$$$XXX$&&&&&&$+;;:.....:;;;
::.:+X$Xx;:+xx+;:;;:.:::....::;:::x&&&&$Xx++++;+xXX$$$Xx++;;xX+:;x$&&&&&&&&&&&&&&&X;;:.:;;....:.;x
;++x+::;xx+;xXX+;::.:;;:..::;;xXXx;.;x$&&&&$$$$&&&&&&&XXxx;.;;;..;xX$&$$&&&&&&$x;..:;+:.:;:..;:;+x
+;.:+xx;:X$X+;;;;:::.:::::..:+++++x+;:.;+X$$$$$&$x;:.::::.:::+::;xX$$x::xxxx;::;+++;:x$+.:x+.::x+;

}
