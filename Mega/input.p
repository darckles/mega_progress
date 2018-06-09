
            
DEFINE STREAM Arq-1.

DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE Linha           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caminho       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo       AS CHARACTER   NO-UNDO.
            
            
            Input Stream Arq-1 From Os-dir(c-caminho) No-attr-list.
            REPEAT : 
                
                /* Faz a leitura de linha por linha do arquivo importado */
                IMPORT STREAM Arq-1 Linha NO-ERROR.
        
                IF SUBSTRING(Linha,13,4) = '.RET' OR Linha MATCHES "*.RET" THEN DO:
                    
        
                    ASSIGN c-arquivo = Linha.
        
                    {&open-query-br-arquivo}
                    
                            
                END.
            END.
                
                
            INPUT STREAM Arq-1 CLOSE.
