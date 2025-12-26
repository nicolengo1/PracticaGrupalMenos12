program turejuveneces;

uses
  UnidadClinica,
  SysUtils;

var
  opcion, subopcion: integer;
  pacienteNuevo: rPaciente;
  arrPacientes: tArrayPacientes;
  resp: string;
  i: integer;
  codigo: string;
  texto: string;
  ficheroPacientes: Text;


begin

  randomize();

  arrPacientes.tope := 0;

  if (not DirectoryExists('.\Archivos')) then
    mkdir('.\Archivos');

  if (not DirectoryExists('.\Archivos\Pacientes')) then
    mkdir('.\Archivos\Pacientes');

  Assign(ficheroPacientes, RUTA_PACIENTES);

  repeat

    menu();

    readln(opcion);

    if (opcion <> 7) then
    begin
      case opcion of
        1: CargarDatos(arrPacientes, ficheroPacientes);

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
            Write(
              'Escriba la fecha de ingreso del paciente siguiendo este formato: "dia mes anio". Importante poner espacios entre cada campo -> ');
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

            AddPaciente(arrPacientes, pacienteNuevo, RUTA_HISTORIAL_PACIENTES);
          end;
        end;
        3..6: begin
          if (arrPacientes.tope = 0) then
            writeln('No hay pacientes en el array!')
          else
          begin
            case opcion of
              3: begin
                MostrarPacientes(arrPacientes);

                repeat
                  SubMenu();

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
              4: MostrarPacientesSeguro(arrPacientes);
              5: begin
                Write('Escriba el codigo del paciente en MAYUSCULAS (porfis) -> ');
                readln(codigo);
                BuscarPacienteCodigo(arrPacientes, codigo);
              end;
              6: writeln('El total facturado de esta clinica es: ',
                  MostrarTotalFacturado(arrPacientes), ' Euros');
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
      Guardar(arrPacientes, ficheroPacientes);
    end;

    writeln();

  until (opcion = 7);
  readln();

end.
