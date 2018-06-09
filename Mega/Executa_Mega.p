DEF  NEW GLOBAL SHARED TEMP-TABLE tt-jogos     NO-UNDO
    FIELD jogos             AS CHAR
    FIELD numeros           AS CHAR EXTENT 6.

DEF NEW GLOBAL SHARED temp-table tt-concurso no-undo
    field numero            as CHAR
    field data              as CHAR format "x(10)"
    field cidade            as CHAR format "x(20)"
    field local             as CHAR format "x(20)"
    field valor_acumulado   as CHAR format "x(20)"
    field dezenas           as CHAR format "x(20)".

DEF NEW GLOBAL SHARED temp-table tt-sena no-undo
    field ganhadores        as char format "x(20)"
    field valor_pago        as char format "x(30)".

DEF NEW GLOBAL SHARED temp-table tt-quina no-undo
    field ganhadores        as char format "x(20)"
    field valor_pago        as char format "x(30)".

DEF NEW GLOBAL SHARED temp-table tt-quadra no-undo
    field ganhadores        as char format "x(20)"
    field valor_pago        as char format "x(30)".

DEF TEMP-TABLE tt-resultado NO-UNDO
    FIELD jogos             AS CHAR FORMAT '99'
    FIELD numeros           AS CHAR EXTENT 6
    FIELD premio            AS CHAR.

DEF TEMP-TABLE  tt-html NO-UNDO
    FIELD html              AS CHAR
    FIELD html2             AS CHAR
    FIELD html3             AS CHAR.

DEF VAR numeros             AS INT EXTENT 6.
DEF VAR num                 AS INT.
DEF VAR cont                AS INT.
DEF VAR prem                AS INT.
DEF VAR classs              AS CHAR.
DEF VAR l-status            AS LOG.
DEF VAR c-mens              AS CHAR.
DEF VAR html                AS LONGCHAR.
DEF VAR ender               AS CHAR.

EMPTY TEMP-TABLE tt-jogos.
EMPTY TEMP-TABLE tt-resultado.
EMPTY TEMP-TABLE tt-concurso.
EMPTY TEMP-TABLE tt-sena.
EMPTY TEMP-TABLE tt-quina.
EMPTY TEMP-TABLE tt-quadra.

    RUN mega.p.
    
    ASSIGN ender = 'C:\Users\dpalmeida\Desktop\Mega\mega.html'.
    
        FOR EACH tt-concurso:
    
            REPEAT cont=1 TO NUM-ENTRIES(tt-concurso.dezenas, "|"):
                   numeros[cont] = int(ENTRY(cont,tt-concurso.dezenas,"|")).
            END.
        END.
    
        FOR EACH tt-jogos:
    
            CREATE tt-resultado.
            REPEAT cont = 1 TO 6:
                REPEAT num=1 TO 6:
                    IF int(tt-jogos.numeros[num]) = numeros[cont]  THEN
                        ASSIGN tt-resultado.jogos = tt-jogos.jogos
                               tt-resultado.numeros[cont] = tt-jogos.numeros[cont].
                END.
            END.
        END.
    
    FIND FIRST tt-concurso  NO-LOCK.
    FIND FIRST tt-quadra    NO-LOCK.
    FIND FIRST tt-quina     NO-LOCK.
    FIND FIRST tt-sena      NO-LOCK.
    
    OUTPUT TO VALUE(ender) CONVERT SOURCE "ISO8859-1" TARGET "UTF-8" .
    
        PUT UNFORMATTED STRING('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><link rel="stylesheet" href="tables.css"><title>Resultado</title>
                <style type="text/css">
                    .pure-table thead ~{background-color: #e0e0e0;color: #000;text-align: left;vertical-align: bottom;}table ~{display: table;border-collapse: separate;border-spacing: 2px;border-color: grey;text-align: center;}text-align: center;.circle-text ~{width:5%;} .num~{background-image:url("http://simev.googlecode.com/svn/trunk/recursos/imagenes/figurasGeometricas/circuloAzul.png");text-align: center;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;
                </style></head><body>
                    <table class="pure-table" style="width: 90%"><thead><th style="text-align: center;font-weight: bold;" colspan="3">SORTEIO</th></thead><tr style="text-align: center;"><td style="text-align: center;font-weight: bold;" colspan="3">' + tt-concurso.numero + '</td></tr>
                        <thead style="text-align: center;font-weight: bold;"><th style="width: 159px; height: 23px">DATA</th><th style="height: 23px" colspan="2">LOCAL</th></thead><tr style="text-align:center;"><td style="width:159px">' + tt-concurso.data + '</td><td>' + tt-concurso.cidade + '</td><td>' + tt-concurso.local + '</td></tr></table><br/>
                    <table style="width: 100%"><thead>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[1]) + '</td>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[2]) + '</td>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[3]) + '</td>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[4]) + '</td>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[5]) + '</td>
                            <td class="num" style="width: 75px; height: 76px;background-repeat:no-repeat;font-size: 30px;padding-bottom:10px;background-position: center;">' + string(numeros[6]) + '</td>
                        </thead></table><br>
                    <table class="pure-table" style="width: 90%">
                        <thead>
                            <th style="width: 50px;border-bottom: 2px solid #D4ACAC">JOGO</th>
                            <th colspan="6" style="width: 200px;border-bottom: 2px solid #D4ACAC;">NUMEROS</th>
                            <th colspan="6" style="width: 200px;border-bottom: 2px solid #D4ACAC;">ACERTOS</th>
                            <th style="width: 150px;border-bottom: 2px solid #D4ACAC;">RESULTADO</th>
                        </thead>
                        <tr style="border-collapse: collapse;border-spacing: 0;empty-cells: show;border: 1px solid #cbcbcb;background-color: #e0e0e0;color: #000;text-align: left;vertical-align: bottom;font-weight: bold;">
                            <td style="width: 40px;">n.</td><td style="width: 40px;">1</td>
                            <td style="width: 40px;">2</td><td style="width: 40px;">3</td>
                            <td style="width: 40px;">4</td><td style="width: 40px;">5</td>
                            <td style="width: 40px;">6</td><td style="width: 40px;">1</td>
                            <td style="width: 40px;">2</td><td style="width: 40px;">3</td>
                            <td style="width: 40px;">4</td><td style="width: 40px;">5</td>
                            <td style="width: 40px;">6</td><td style="width: 150px;">Premio</td>
                        </tr>').
                        
            FOR EACH tt-resultado
                WHERE tt-resultado.jogos <> "",
                    EACH tt-jogos
                        WHERE tt-jogos.jogos    =   tt-resultado.jogos
            BY tt-resultado.jogos:
        
                prem = 0.
                REPEAT cont = 1 TO 6:
                    IF (tt-resultado.numeros[cont] <> "") THEN
                        prem = prem + 1.
                END.
        
                classs = ''.
                CASE prem:
        
                    WHEN 2 THEN
                        ASSIGN  tt-resultado.premio = 'DUQUE'
                                classs              = 'background-color: #dff4d4'.
                    WHEN 3 THEN
                        ASSIGN  tt-resultado.premio = 'TERNO'
                                classs              = 'background-color: #c2e0f6'.
                    WHEN 4 then
                        ASSIGN  tt-resultado.premio = 'QUADRA'
                                classs              = 'background-color: #fff966'.
                    WHEN 5 then
                        ASSIGN  tt-resultado.premio = 'QUINA'
                                classs              = 'background-color: #f0a982'.
                    WHEN 6 THEN
                        ASSIGN  tt-resultado.premio = 'MEGA!!!'
                                classs              = 'background-color: #f94040'.
        
                END CASE.
        PUT UNFORMATTED '<tr style="' + classs + '">
                        <td style="width: 30px;">' + string(tt-resultado.jogos)  + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[1]) + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[2]) + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[3]) + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[4]) + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[5]) + '</td>
                        <td style="width: 30px;">' + string(tt-jogos.numeros[6]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[1]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[2]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[3]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[4]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[5]) + '</td>
                        <td style="width: 25px;font-weight: bold">' + string(tt-resultado.numeros[6]) + '</td>
                        <td style="width: 100px;font-weight: bold;">' + string(tt-resultado.premio) + '</td>
                        </tr>
                    </tbody>'.
                    
            END.
        PUT UNFORMATTED '|</table><br>'.
        
        PUT UNFORMATTED '<table class="pure-table" style="width: 100%">
                <tr style="border-collapse: collapse;border-spacing: 0;empty-cells: show;border: 1px solid #cbcbcb;background-color: #e0e0e0;color: #000;vertical-align: bottom;font-weight: bold;">
                    <td style="width: 99px; height: 22px">DATA</td>
                    <td style="height: 22px">SENA</td>
                    <td style="height: 22px" >QUINA</td>
                    <td style="height: 22px">QUADRA</td>
                </tr>
                <tr style="font-weight: bold;">
                    <td style="width: 99px;text-align: center"  rowspan="2">' + tt-concurso.data + '</td>
                    <td style="width: 193px;background-color: #e0e0e0;text-align: center">Ganhadores</td>
                    <td style="width: 193px;background-color: #e0e0e0;text-align: center">Ganhadores</td>
                    <td style="width: 182px;background-color: #e0e0e0;text-align: center">Ganhadores</td>
                </tr>
                <tr>
                <td style="width: 193px; height: 38px;">' + tt-sena.ganhadores + '</td> 
                <td style="width: 193px; height: 38px;">' + tt-quina.ganhadores + '</td> 
                <td style="height: 38px; width: 182px;">' + tt-quadra.ganhadores + '</td>
                </tr>
                <tr style="background-color: #e0e0e0;font-weight: bold;"><td style="width: 99px;text-align: center">Acumulado</td>
                <td style="width: 193px;text-align: center">Valor Pago</td><td style="width: 193px;text-align: center">Valor Pago</td>
                <td style="width: 182px;text-align: center">Valor Pago</td>
                </tr>
                <tr>
                    <td style="width: 99px;"> ' + tt-concurso.valor_acumulado + '</td>
                    <td style="width: 193px;">' + tt-sena.valor_pago + '</td>
                    <td style="width: 193px;">' + tt-quina.valor_pago + '</td>
                    <td style="width: 182px;">' + tt-quadra.valor_pago + '</td>
                </tr>
            </table></body></html>'.
            
        PUT UNFORMATTED '|'.            
    
     OUTPUT CLOSE. 
    
    INPUT FROM  value(ender).
    REPEAT:
        CREATE tt-html.
        IMPORT DELIMITER "|":U tt-html .
    END.
    INPUT CLOSE.
    
    FOR EACH tt-html:
    
        html =html + tt-html.html + tt-html.html2.
        
    END.
    
        RUN correio.p (input "darckles.almeida@grupopepsio.com.br",
                       input "",
                       input "Resultado da Loteria",
                       input string(html),
                       input "",
                       output l-status).
    
    
