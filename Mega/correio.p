def input  parameter m_mail-1 As Char.
def input  parameter m_mail-2 As Char.
def input  parameter c-titulo AS CHAR.
def input  parameter c-mens   AS CHAR.
def input  parameter c-attach AS CHAR.
def output parameter l-status as logical.

def VAR c-attach1   AS CHAR.

def var i-contador as Integer.

def var h-outlook AS COM-HANDLE.
def var h-item    AS COM-HANDLE.

/*message m_mail-1 view-as alert-box.*/

create "Outlook.Application" h-outlook no-error.

if not error-status:error then do:

  h-item = h-outlook:CreateItem(0).
  h-item:Session:Logon NO-ERROR.
  
  if error-status:error then do:
     message "Erro ao logar no correio, favor comunicar o departamento de informatica." 
     view-as alert-box.
     leave.
  end.       
  
  h-item:To = m_mail-1.
  h-item:Subject = c-titulo.

  h-item:HTMLBody = c-mens.  /* REPLACE(c-mens,c-salta,"<BR>"). */
  if c-attach <> "" then do:
      if num-entries(c-attach,';') = 1 then
          h-item:Attachments:add(c-attach).

      else do:
          do i-contador = 1 to num-entries(c-attach,';'):

             h-item:Attachments:add(trim(entry(i-contador,c-attach,';'))).
          End.
      End.
  End.

  h-item:Send().

  RELEASE OBJECT h-item NO-ERROR.

  if m_mail-2 <> "" then do:
     h-item = h-outlook:CreateItem(0).
     h-item:Session:Logon NO-ERROR.
  
     if error-status:error then do:
        message "Erro ao logar no correio, favor comunicar o departamento de informatica." 
        view-as alert-box.
        leave.
     end.       
  
     h-item:To = m_mail-2.
     h-item:Subject = c-titulo.
  
     h-item:HTMLBody = c-mens.  /* REPLACE(c-mens,c-salta,"<BR>"). */     
     if c-attach <> "" THEN DO:
        h-item:Attachments:add(c-attach).
     END.

     h-item:Send().

     RELEASE OBJECT h-item NO-ERROR.
  end.
end.

else
  MESSAGE "Erro ao conectar no correio, favor comunicar o departamento de informatica" VIEW-AS ALERT-BOX.

release object h-outlook no-error.
