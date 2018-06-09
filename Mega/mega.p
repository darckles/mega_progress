DEF NEW GLOBAL SHARED TEMP-TABLE tt-jogos     NO-UNDO
    FIELD jogos             AS CHAR
    FIELD numeros           AS CHAR EXTENT 6.

DEF NEW GLOBAL SHARED  TEMP-TABLE tt-resultado NO-UNDO
    FIELD jogos             AS CHAR FORMAT '99'
    FIELD numeros           AS CHAR EXTENT 6.

DEF NEW GLOBAL SHARED  temp-table tt-concurso no-undo
    field numero            as CHAR
    field data              as CHAR format "x(10)"
    field cidade            as CHAR format "x(20)"
    field local             as CHAR format "x(20)"
    field valor_acumulado   as CHAR format "x(20)"
    field dezenas           as CHAR format "x(20)".

DEF NEW GLOBAL SHARED  temp-table tt-sena no-undo
    field ganhadores  as char format "x(20)"
    field valor_pago as char format "x(30)".

DEF NEW GLOBAL SHARED  temp-table tt-quina no-undo
    field ganhadores  as char format "x(20)"
    field valor_pago as char format "x(30)".

DEF NEW GLOBAL SHARED temp-table tt-quadra no-undo
    field ganhadores  as char format "x(20)"
    field valor_pago as char format "x(30)".
    
DEF NEW GLOBAL SHARED temp-table tt-proximo no-undo
    field data  as char format "x(20)"
    field valor_estimado as char format "x(30)".
    
DEF TEMP-TABLE tt-dezenas no-undo
    field num1  as CHAR format "x(2)"
    field num2  as CHAR format "x(2)"
    field num3  as CHAR format "x(2)"
    field num4  as CHAR format "x(2)"
    field num5  as CHAR format "x(2)"
    field num6  as CHAR format "x(2)".
    
def var h-sax  as handle no-undo.
def var h-tt   as handle no-undo. /* handle to the current temp-table (parent node) */
def var c-node as char   no-undo. /* current child node (temp-table field) */

DEF VAR c-arq   AS CHAR  INITIAL "C:\Users\dpalmeida\Desktop\Mega\mega.csv".
DEF VAR c-xml   AS CHAR INITIAL "C:\Users\dpalmeida\Desktop\Mega\mega.xml".

    RUN pi-xml.
    
    /* Main Block */
    create sax-reader h-sax.
    h-sax:handler = this-procedure.
    h-sax:set-input-source("file", c-xml). /* file must be in the current working directory */
    h-sax:sax-parse().
    
        INPUT FROM VALUE(c-arq).
            REPEAT:
                CREATE tt-jogos.
                IMPORT DELIMITER ";" tt-jogos.
            END.
        INPUT CLOSE.
    
    FOR EACH tt-dezenas:
        CREATE tt-concurso.
        ASSIGN tt-concurso.dezenas  =   tt-dezenas.num1 + '|' 
                                    +   tt-dezenas.num2 + '|' 
                                    +   tt-dezenas.num3 + '|' 
                                    +   tt-dezenas.num4 + '|' 
                                    +   tt-dezenas.num5 + '|' 
                                    +   tt-dezenas.num6. 
    END.
    
    /* for each tt-concurso:                        */
    /*     disp tt-concurso with title "CONCURSO".  */
    /* end.                                         */
    
    
    /* for each tt-sena:                    */
    /*     disp tt-sena with title "SENA".  */
    /* end.                                 */
    
    
    /* for each tt-quina:                     */
    /*     disp tt-quina with title "QUINA".  */
    /* end.                                   */
    
    
    /* for each tt-quadra:                      */
    /*     disp tt-quadra with title "QUADRA".  */
    /* end.                                     */
    
    for each tt-jogos
        BY tt-jogos.jogos:
        
            IF length(tt-jogos.jogos) = 1 THEN DO:
                ASSIGN  tt-jogos.jogos = '0' + tt-jogos.jogos.
            END.
            
            CREATE tt-resultado.
            ASSIGN tt-resultado.jogos = tt-jogos.jogos.
        
    /*     disp tt-jogos with title "JOGOS".  */
    end.
    
    /* FOR EACH tt-resultado                          */
    /*     BY tt-resultado.jogos :                    */
    /*                                                */
    /*     disp tt-resultado with title "Resultado".  */
    /* END.                                           */
    
    
    /* SAX-READER Callbacks */
    procedure characters:
        def input parameter charData as longchar no-undo.
        def input parameter numChars as int      no-undo.
    
        if not valid-handle(h-tt) then return.
    
        h-tt:buffer-field(c-node):buffer-value = charData no-error.
        
    end.
    
    procedure StartElement:
        def input param namespaceURI as char   no-undo.
        def input param localName    as char   no-undo.
        def input param qName        as char   no-undo.
        def input param attributes   as handle no-undo.
    
        case qName:
            
            when "concurso" then do:
                create tt-concurso.
                h-tt = buffer tt-concurso:handle.
            end.
            when "numeros_sorteados" then do:
                create tt-dezenas.
                h-tt = buffer tt-dezenas:handle.
            end.
            
            when "sena" then do:
                create tt-sena.
                h-tt = buffer tt-sena:handle.
            end.
            when "quina" then do:
                create tt-quina.
                h-tt = buffer tt-quina:handle.
            end.
            when "quadra" then do:
                create tt-quadra.
                h-tt = buffer tt-quadra:handle.
            end.
            otherwise do:
                assign c-node = qName.
            end.
        end case.
    end.
    
    procedure EndElement:
        def input param namespaceuri as char no-undo.
        def input param localname    as char no-undo.
        def input param qname        as char no-undo.
    
        if qName = "mega_virada_valor_acumulado" then
            self:stop-parsing.
    end.
    
    
    PROCEDURE pi-xml:
    
        DEF VAR http                AS COM-HANDLE   NO-UNDO. 
        DEF VAR retorno             AS CHAR         NO-UNDO.
        DEF VAR strURL              AS CHAR         NO-UNDO.
        DEF VAR c-temp              AS CHAR         NO-UNDO.
    
            ASSIGN  strURL      =   'http://developers.agenciaideias.com.br/loterias/megasena/xml'
                    c-temp      =   c-xml.
    
            CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR. /* Chamada da Dll de conex? http*/
                    http:OPEN("GET", strURL, FALSE).        /*Abre a conex? */
                    http:setRequestHeader("Translate", "f"). 
                    http:setRequestHeader("Depth", "0").
                    http:SEND() NO-ERROR.
                    
                    retorno =   trim(http:responseText).
                    retorno = TRIM(REPLACE(TRIM(retorno),"~011","")).
                    
                    
                 ASSIGN    
                        ENTRY(15,retorno,'>')  =    "<num1"
                        ENTRY(17,retorno,'<')  =    "/num1>"
                        
                        ENTRY(17,retorno,'>')  =    "<num2"
                        ENTRY(19,retorno,'<')  =    "/num2>"
                        
                        ENTRY(19,retorno,'>')  =    "<num3"
                        ENTRY(21,retorno,'<')  =    "/num3>"
                        
                        ENTRY(21,retorno,'>')  =    "<num4"
                        ENTRY(23,retorno,'<')  =    "/num4>"
                        
                        ENTRY(23,retorno,'>')  =    "<num5"
                        ENTRY(25,retorno,'<')  =    "/num5>"
                        
                        ENTRY(25,retorno,'>')  =    "<num6"
                        ENTRY(27,retorno,'<')  =    "/num6>".
                     
                    retorno = TRIM(REPLACE(REPLACE(retorno,CHR(10),""),CHR(13),"")).
                    retorno = TRIM(retorno).
    
                    OUTPUT TO VALUE(c-temp) CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
    
                        put unformatted   trim(retorno) .
        
                    OUTPUT CLOSE.
    END PROCEDURE.
    
    
