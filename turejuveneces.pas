program turejuveneces;

uses UnidadClinica;

var 
opcion := integer;


begin

randomize();

 repeat

    menu();

    readln(opcion);

    if (opcion <> 7) then
    begin
    case  of opcion
    1:if (arpaciente.tope >= MAX_ARRAY) then
       writeln('No se pueden agregar mas pacientes, capacidad maxima alcanzada !')
      else
      begin


        AddPaciente()//ArrPaciente y paciente
      end;
        

    2:
    3:
    4:
    5:
    6:
    else
    writeln('Opcion incorrecta!');
        
    end;

    else
    begin
     writeln('byebyeee');
      // procedure guardar
    end;
    
 until (opcion = 7);

end.

