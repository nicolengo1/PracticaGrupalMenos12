unit UnidadClinica;

interface

const
  MAX_ARRAY = 2000;
  MIN = 0;

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
    codigoHistorial: string; // hasta 9 numeros y letras
    tieneSeguro:Boolean;
    totalFacturado:integer;
   end;

   tArray = Array[MIN..MAX_ARRAY - 1] of tPaciente;// max 2000 pacientes
   
   tArrayPacientes = Record
    pacientes : tArray;
    tope:integer; // no lo limito
   end;


 procedure Submenu();
 procedure Menu();
 procedure CargarDatos(arpaciente:tArray); 
 procedure AddPaciente(VAR arpaciente:tArrayPacientes; paciente:tpaciente);
 procedure MostrarPacientes(arpaciente:tArrayPacientes); 
 procedure MostrarPacientesSeguro (arpaciente:tArrayPacientes); // con seguro medico
 function MostrarTotalFacturado(arpaciente:tArrayPacientes):integer;  // devuelve el total facturado por todos los pacientes
 procedure guardar(ficha:text;arpaciente: tArrayPacientes);

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

procedure CargarDatos(arpaciente:tArray);
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


procedure AddPaciente(VAR arpaciente:tArrayPacientes; pacienteNuevo:tpaciente);
 begin 
    arpaciente.paciente[arapciente.tope]:= pacienteNuevo; // Cargamos los datos del nuevo paciente en la posicion del tope
    arpaciente.tope := arpaciente.tope + 1; // Incrementamos tope
    
    // Ordenar
 end;

procedure MostrarPacientes(arpaciente: tArrayPacientes);
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
  for i:= MIN to arpaciente.tope - 1 do
  begin
    writeln(i+1, 'Paciente ', arpaciente.pacientes[i].nombre, ' ', arpaciente.pacientes[i].apellidos,', de sexo ', arpaciente.pacientes[i].sexo,', con el codigo - ', arpaciente.pacientes[i].codigoHistorial,', ingresado en la fecha ', MostrarFechaIngreso(arpaciente.pacientes[i].ingreso), ', ', ConSeguro, ', ', arpaciente.pacientes[i].totalFacturado)
  end;
end;

procedure MostrarPacientesSeguro (arpaciente:tArrayPacientes);
var
  i:integer;
  banderita:boolean;
begin
existePaciente := False; //  variable para saber si hay pacientes con seguro medico
  
  for i:= MIN to arpaciente.tope - 1 do
    begin 
      if (arpaciente.pacientes[i].tieneSeguro = true) then
        begin
          existePaciente := True; // Sabemos que existe al menos un paciente con seguro
          writeln(i+1, ': ',arpaciente.pacientes[i].nombre,' ',arpaciente.pacientes[i].apellidos);   
        end;   
    end;
    if (existePaciente = True) then
      begin
      writeln
      end;
end;

function MostrarTotalFacturado(arpaciente:tArrayPacientes):integer;
var
  FacturadoPaciente:integer;
begin
  FacturadoPaciente:= MIN;

  for i:= MIN to arpaciente.tope - 1 do
    begin
      FacturadoPaciente:= FacturadoPaciente + arpaciente.pacientes[i].totalFacturado;
      MostrarTotalFacturado := FacturadoPaciente;
    end;

end;

procedure guardar(var ficha:text;arpaciente: tArrayPacientes); // hay que pedir confirmación en el case para cerrar programa
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
   writeln(ficha,'Nombre:', arpaciente.paciente[i].nombre); 
   writeln(ficha,'Apllido:', arpaciente.paciente[i].apellidos);
   writeln(ficha,'Ingreso:', arpaciente.paciente[i].ingreso); // hay que
   writeln(ficha,'Nombre:', arpaciente.paciente[i].nombre);
   writeln(ficha,'Nombre:', arpaciente.paciente[i].nombre);
   writeln(ficha,'Nombre:', arpaciente.paciente[i].nombre);
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