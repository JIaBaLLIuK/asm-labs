.386
.MODEL FLAT, C
.CODE
FindSin PROC C arrayElement: dword  
  finit
  
  fld arrayElement
  fsin

  ret
FindSin endp
end