unit UnidadClinica;

interface

const
  MAX_ARRAY = 2000;
  MIN_ARRAY = 0;

TYPE

    tIngreso = Record
      dia: integer;
      mes: integer;
      anyo: integer; 
    end;
    
   tPaciente = Record
    nombre:string;
    apellidos:string;
    sexo:string; // hombre / mujer en minusculas
    ingreso: tIngreso;
    codigoHistorial: string; // hasta 9 letras
    tieneSeguro:Boolean;
    totalFacturado:integer;
   end;

   tArray = Array[MIN_ARRAY..MAX_ARRAY - 1] of tPaciente; // max 2000 pacientes
   
   tArrayPacientes = Record
    pacientes : tArray;
    tope:integer; // no lo limito
   end;


 procedure Submenu();
 procedure Menu();

 procedure CargarDatos(arrPacientes:tArray); 
 procedure AddPaciente(VAR arrPacientes:tArrayPacientes; paciente:tpaciente);
 procedure MostrarPacientes(arrPacientes:tArrayPacientes); 
 procedure MostrarPacientesSeguro (arrPacientes:tArrayPacientes); // con seguro medico
 procedure MostrarTotalFacturado(arrPacientes:tArrayPacientes);  // devuelve el total facturado por todos los pacientes
 procedure guardar(fichero:text;arrPacientes: tArrayPacientes);

implementation


procedure Submenu();
begin
  writeln('Que deseas hacer ahora? Elija una opcion: ');
  writeln('-------------------------');
  writeln('1. Ver historial clinico');
  writeln('2. Agregar entrada al historial del paciente');
  writeln('3. Salir. Volver al menu principal');
end;


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


procedure CargarDatos(arrPacientes:tArray);
var
  fichero: text;
  i: integer;
begin
  assign(fichero,'./Archivos/tpacientes.txt');
  
  {$I-}
  reset(fichero);
  {$I+}

  if (IORESULLT <> 0) then
  begin
    writeln('El archivo no existe! ( Algun error ha pasado )')
  end
  else
    i:= MIN;
    repeat
    // leer cada linea hasta end of line y meter datos en el array de [i]

    until EOFL; // end of file o como se llame y until i = 1999 si eso
  end;
  
  close(fichero);

end;


procedure AddPaciente(VAR arrPacientes:tArrayPacientes; pacienteNuevo:tpaciente);
 begin 
    arrPacientes.paciente[arapciente.tope]:= pacienteNuevo; // Cargamos los datos del nuevo paciente en la posicion del tope
    arrPacientes.tope := arrPacientes.tope + 1; // Incrementamos tope
    
    // Ordenar
 end;


procedure MostrarPacientes(arrPacientes: tArrayPacientes);
var
  i:integer;

  function MostrarFechaIngreso(ingreso :tIngreso):string;
  begin
    MostrarFechaIngreso := ingreso.dia + '/' + ingreso.mes, '/' + ingreso.anyo; // devuelve un string
  end;

  function ConSeguro (tieneSeguro:Boolean):string;
  begin
    if(tieneSeguro = True)then
      ConSeguro := 'con seguro medico'
    else
      ConSeguro := 'sin seguro medico'  
  end;

begin
  for i:= 0 to arrPacientes.tope - 1 do
  begin
    writeln(i+1, 'Paciente ', arrPacientes.pacientes[i].nombre, ' ', arrPacientes.pacientes[i].apellidos);
    writeln(', de sexo ', arrPacientes.pacientes[i].sexo,', con el codigo - ', arrPacientes.pacientes[i].codigoHistorial);
    writeln(', ingresado en la fecha ', MostrarFechaIngreso(arrPacientes.pacientes[i].ingreso), ', ', ConSeguro); 
    writeln(', con el total facturado', arrPacientes.pacientes[i].totalFacturado)
  end;
end;


procedure MostrarPacientesSeguro (arrPacientes:tArrayPacientes);
var
  i:integer;
  banderita:boolean;

  function MostrarFechaIngreso(ingreso :tIngreso):string;
  begin
    MostrarFechaIngreso := ingreso.dia + '/' + ingreso.mes, '/' + ingreso.anyo; // devuelve un string
  end;

begin
existePaciente := False; //  variable para saber si hay pacientes con seguro medico
  
  for i:= MIN_ARRAY to arrPacientes.tope - 1 do
    begin 
      if (arrPacientes.pacientes[i].tieneSeguro = true) then
        begin
          existePaciente := True; // Sabemos que existe al menos un paciente con seguro
          writeln(i+1, 'Paciente ', arrPacientes.pacientes[i].nombre, ' ', arrPacientes.pacientes[i].apellidos);
          writeln(', de sexo ', arrPacientes.pacientes[i].sexo,', con el codigo - ', arrPacientes.pacientes[i].codigoHistorial);
          writeln(', ingresado en la fecha ', MostrarFechaIngreso(arrPacientes.pacientes[i].ingreso), ); 
          writeln(', con el total facturado', arrPacientes.pacientes[i].totalFacturado)   
        end;   
    end;
    if (existePaciente = True) then
      begin
      writeln
      end;
end;


procedure MostrarTotalFacturado(arrPacientes:tArrayPacientes):integer;
var
  FacturadoPaciente:integer;
begin
  FacturadoPaciente:= 0;

  for i:= MIN to arrPacientes.tope - 1 do
    begin
      FacturadoPaciente:= FacturadoPaciente + arrPacientes.pacientes[i].totalFacturado;
    end;

end;

procedure guardar(var ficha:text;arrPacientes: tArrayPacientes); // hay que pedir confirmación en el case para cerrar programa
var
i:= integer;
begin
assing(ficha,'tpacientes.txt');
{$-}
reset(ficha);
{$+}
if IORESULT <> 0 then
  writeln('No existe el archivo')
else
rewrite(ficha);
  for i:= MIN to MAX_ARRAY-1 then
  begin
   writeln(ficha,'Nombre:', arrPacientes.paciente[i].nombre); 
   writeln(ficha,'Apllido:', arrPacientes.paciente[i].apellidos);
   writeln(ficha,'Ingreso:', arrPacientes.paciente[i].ingreso); // hay que
   writeln(ficha,'Nombre:', arrPacientes.paciente[i].nombre);
   writeln(ficha,'Nombre:', arrPacientes.paciente[i].nombre);
   writeln(ficha,'Nombre:', arrPacientes.paciente[i].nombre);
  end;

 
writeln('¡Datos guardados con exito!');
end;

// nombre:string;
//    apellidos:string;
//   sexo:string; // hombre / mujer en minusculas
//    ingreso: tIngreso;
//    codigoHistorial: string; // hasta 9 numeros y letras
//    tieneSeguro:Boolean;
//    totalFacturado:integer;
END.