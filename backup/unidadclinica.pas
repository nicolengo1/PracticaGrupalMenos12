unit UnidadClinica;

interface

uses Dos, SysUtils;

const
  MAX_ARRAY = 2000; // De 0 a 2000 -1 son 2000 en total
  RUTAPACIENTES = '.\Archivos\tpacientes.txt';
  RUTAHISTORIALPACIENTES = '.\Archivos\Pacientes';

type

  rIngreso = record
    dia: integer;
    mes: integer;
    anio: integer;
  end;

  rPaciente = record
    nombre: string;
    apellidos: string;
    edad: integer; // se puede limitar
    sexo: char; // caracter h / m de hombre o mujer
    ingreso: rIngreso;
    codigoHistorial: string; // 9 letras aleatorias
    tieneSeguro: boolean;
    totalFacturado: integer;
  end;

  tArray = array[0..MAX_ARRAY - 1] of rPaciente; // max 2000 pacientes

  tArrayPacientes = record
    pacientes: tArray;
    tope: integer; // no lo limito
  end;


procedure Menu();
procedure Submenu();

procedure CargarDatos(var arrPacientes: tArrayPacientes; RUTAPACIENTES: string);
// punto 1
procedure AddPaciente(var arrPacientes: tArrayPacientes; pacienteNuevo: rPaciente;
  RUTAHISTORIALPACIENTES: string);
// punto 2
procedure MostrarPacientes(var arrPacientes: tArrayPacientes); // punto 3
procedure MostrarPacientesSeguro(var arrPacientes: tArrayPacientes); // punto 4
procedure BuscarPacienteCodigo(var arrPacientes: tArrayPacientes;
  codigo: string); // punto 5
procedure MostrarTotalFacturado(var arrPacientes: tArrayPacientes); // punto 6
procedure Guardar(var arrPacientes: tArrayPacientes); // punto 7

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
begin
  writeln('Que deseas hacer ahora? Elija una opcion: ');
  writeln('-------------------------');
  writeln('1. Ver historial clinico de un paciente');
  writeln('2. Agregar entrada al historial del paciente');
  writeln('3. Volver atras.');
end;

procedure CargarDatos(var arrPacientes: tArrayPacientes; RUTAPACIENTES: string);
// punto 1
var
  fichero: Text;
  i: integer;
  pacienteNuevo: rPaciente;
  texto: string;
begin

  if (not DirectoryExists('.\Archivos')) then
    mkdir('.\Archivos');

  Assign(fichero, RUTAPACIENTES);

  {$I-}
  reset(fichero);
  {$I+}

  if (IORESULT <> 0) then
  begin
    writeln('El archivo no existe! ( Algun error ha pasado )');
  end
  else
  begin
    i := 0;

    while (i < 2000) and (not EOF(fichero)) do
    begin
      Readln(fichero, texto);

      pacienteNuevo.nombre := copy(texto, 1, pos(' ', texto) - 1);
      Delete(texto, 1, pos(' ', texto));

      pacienteNuevo.apellidos := copy(texto, 1, pos('|', texto) - 1);
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.edad := StrToInt(copy(texto, 1, pos('|', texto) - 1));
      Delete(texto, 1, pos('|', texto));

      pacienteNuevo.sexo := copy(texto, 1, pos('|', texto) - 1);
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

      i := i + 1;

    end;
    // end of file o como se llame y until i = 1999 si eso

    if (i = 2000) and not EOF(fichero) then
      writeln('Se ha alcanzado el tope del array, el resto de datos no se han cargado!');

    Close(fichero);

    arrPacientes.tope := i;

    if (i = 0) then
      writeln('El archivo esta vacio!');

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
  // Cargamos los datos del nuevo paciente en la posicion del tope
  arrPacientes.tope := arrPacientes.tope + 1; // Incrementamos tope

  if (not DirectoryExists('.\Archivos')) then
    mkdir('.\Archivos');

  if (not DirectoryExists('.\Archivos\Pacientes')) then
    mkdir('.\Archivos\Pacientes');

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
    Write(fichero, 'test');
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

end;

procedure VerHistorial(var arrPacientes: tArrayPacientes; codigo: string); // punto 3
var
  fichero: Text;
  frase: string;
begin
  Assign(fichero, RUTAHISTORIALPACIENTES + codigo + '.txt');

  {$I-}
  reset(fichero);
  {$I+}

  if IORESULT <> 0 then
    writeln('Fichero o paciente no encontrado')
  else
    while (not EOF(fichero)) do
    begin
      Readln(fichero, frase);
      Writeln(frase);
    end;

  Close(fichero);
end;

procedure AddHistorial(var arrPacientes: tArrayPacientes; codigo, texto: string);
var
  fichero: Text;
  dia, diaMes, anyo, diaSemana: word;
begin
  Assign(fichero, RUTAHISTORIALPACIENTES + codigo + '.txt');
  {$I-}
  append(fichero);
  {$I+}

  if IORESULT <> 0 then
    writeln('Fichero o paciente no encontrado')
  else
  begin
    getDate(anyo, diaMes, diaMes, diaSemana);
    writeln(fichero, dia, '/', diaMes, '/', anyo, ' - ', texto);
    Close(fichero);
  end;

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
      writeln(i + 1, '- Paciente ', arrPacientes.pacientes[i].nombre, ' ',
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
    writeln('Paciente no encontrado')
  else
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

end;


procedure MostrarTotalFacturado(var arrPacientes: tArrayPacientes); // punto 6
var
  i, facturadoPaciente: integer;
begin
  facturadoPaciente := 0;

  for i := 0 to arrPacientes.tope - 1 do
  begin
    facturadoPaciente := facturadoPaciente + arrPacientes.pacientes[i].totalFacturado;
  end;

  writeln('El total facturado de esta clinica es: ', facturadoPaciente);

end;

procedure Guardar(var arrPacientes: tArrayPacientes); // punto 7
var
  i: integer;
  fichero: Text;
begin

  if (not DirectoryExists('.\Archivos')) then
    mkdir('.\Archivos');

  Assign(fichero, RUTAPACIENTES);
  {$-}
  rewrite(fichero);
  {$+}
  if IORESULT <> 0 then
    writeln('No existe el archivo')
  else
    rewrite(fichero);
  for i := 0 to arrPacientes.tope - 1 do
  begin
    Write(fichero, arrPacientes.pacientes[i].nombre, ' ',
      arrPacientes.pacientes[i].apellidos);
    Write(fichero, '|', arrPacientes.pacientes[i].edad);
    Write(fichero, '|', arrPacientes.pacientes[i].sexo);
    Write(fichero, '|', arrPacientes.pacientes[i].codigoHistorial);
    Write(fichero, '|', arrPacientes.pacientes[i].ingreso.dia);
    Write(fichero, '|', arrPacientes.pacientes[i].ingreso.mes);
    Write(fichero, '|', arrPacientes.pacientes[i].ingreso.anio);
    Write(fichero, '|', arrPacientes.pacientes[i].tieneSeguro);
    Write(fichero, '|', arrPacientes.pacientes[i].totalFacturado);
    writeln(fichero);
  end;
  // Nombre apellido | edad | sexo | codigo | dia | mes | anyo | tieneSeguro | total facturado
  // Ejemplos:
  // María Gómez|22|F|HCRRTQAET|15|5|2024|TRUE|243.50
  // Juan Pérez|32|M|MAAEWAJZW|15|5|2025|TRUE|2434.50

  Close(fichero);
end;

end.
