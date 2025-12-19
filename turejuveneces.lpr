program turejuveneces;

uses
  UnidadClinica;

  // rIngreso = Record
  //       dia: integer;
  //       mes: integer;
  //       anio: integer;
  //     end;

  //    rPaciente = Record
  //     nombre:string;
  //     apellidos:string;
  //     edad:integer; // se puede limitar
  //     sexo:char; // caracter h / m de hombre o mujer
  //     ingreso: rIngreso;
  //     codigoHistorial: string; // 9 letras aleatorias
  //     tieneSeguro:Boolean;
  //     totalFacturado:integer;
  //    end;

  //    tArray = Array[0..MAX_ARRAY - 1] of rPaciente; // max 2000 pacientes

  //    tArrayPacientes = Record
  //     pacientes : tArray;
  //     tope:integer; // no lo limito
  //    end;
var
  opcion: integer;
  pacienteNuevo: rPaciente;
  arrPacientes: tArrayPacientes;
  resp: string;
  i: integer;

begin

  randomize();

  arrPacientes.tope := 0;

  repeat

    menu();

    readln(opcion);

    if (opcion <> 7) then
    begin
      case opcion of
        1: CargarDatos(arrPacientes, RUTAPACIENTES);

        2: begin
          if (arrPacientes.tope >= MAX_ARRAY) then
            writeln('No se pueden agregar mas pacientes, capacidad maxima alcanzada !')
          else
          begin
            Write('Escriba el nombre del paciente - > ');
            readln(pacienteNuevo.nombre);
            Write('Escriba el apellido del paciente -> ');
            readln(pacienteNuevo.apellidos);
            Write('Escriba la edad del paciente -> ');
            readln(pacienteNuevo.edad);
            Write('Escriba el genero del paciente ( hombre como h y mujer como m ) -> ');
            readln(pacienteNuevo.sexo);
            Write('Escriba la fecha de ingreso del paciente siguiendo este formato: "dia mes anio". Importante poner espacios entre cada campo -> ');
            Read(pacienteNuevo.ingreso.dia);
            Read(pacienteNuevo.ingreso.mes);
            readln(pacienteNuevo.ingreso.anio);
            Write('Escriba si el paciente tiene seguro, responda con "si" o "no" -> ');
            readln(resp);
            if (resp = 'si') then
              pacienteNuevo.tieneSeguro := True
            else
              pacienteNuevo.tieneSeguro := False;
            Write('Escriba el numero total de la facturacion -> ');
            readln(pacienteNuevo.totalfacturado);

            pacienteNuevo.codigoHistorial := '';

            for i := 1 to 9 do
              pacienteNuevo.codigoHistorial :=
                pacienteNuevo.codigoHistorial + chr(random(25) + 65);

            AddPaciente(arrPacientes, pacienteNuevo, RUTAHISTORIALPACIENTES);
          end;
        end;
        3..6: begin
          if (arrPacientes.tope = 0) then
            writeln('No hay pacientes en el array!')
          else
          begin
            case opcion of
              3: MostrarPacientes(arrPacientes);
              4: MostrarPacientesSeguro(arrPacientes);
              5: begin
                // pedir codigo y todo
                // BuscarPacientePorCodigo(arrPacientes,codigo);
              end;
              6: MostrarTotalFacturado(arrPacientes);
            end;
          end;
        end
        else
          writeln('Opcion incorrecta!');

      end;
    end

    else
    begin
      writeln('Saliendo...');
      writeln('Gracias por usar este programa!');
      Guardar(arrPacientes);
    end;

    writeln();

  until (opcion = 7);
  readln();

end.
