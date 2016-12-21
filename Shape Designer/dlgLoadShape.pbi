;{ ==Code Header Comment==============================
;        Name/title: dlgLoadIcon.pbi
;   Executable name: Part of Icondesigner.exe
;           Version: 1.0.0
;            Author: Collectordave
;     Collaborators: 
;    Translation by: 
;       Create date: 16\05\2016
; Previous releases: 
; This Release Date: 
;  Operating system: Windows  [X]GUI
;  Compiler version: PureBasic 5.42LTS(x64)
;         Copyright: (C)2016
;           License: 
;         Libraries: 
;     English Forum: 
;      French Forum: 
;      German Forum: 
;  Tested platforms: Windows
;       Description: Module to display and save iconfiles
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

EnableExplicit
DeclareModule LoadShape
  
  Global OkPressed.i
  Global SelectedShapeID.i
  Declare.i Open() 
  
EndDeclareModule

Module LoadShape

  Global dlgLoadIcon

  Global txtSelectGroup, txtSelectIcon, cmbShape, btnOk, btnCancel
     
  Procedure LoadShapescmb()
    
    If DatabaseQuery(Main::ShapesDB, "SELECT * FROM Shapes ORDER BY Name ASC;")
      
      ClearGadgetItems(cmbShape)  

        While NextDatabaseRow(Main::ShapesDB)
          AddGadgetItem(cmbShape, -1, GetDatabaseString(Main::ShapesDB, 1))
        Wend
        FinishDatabaseQuery(Main::ShapesDB)
    
    EndIf
     
EndProcedure

Procedure.i GetShapeID()
  
  Define ShapeID.i = -1

  If Len(GetGadgetText(cmbShape)) > 0
    If DatabaseQuery(Main::ShapesDB, "SELECT * FROM Shapes WHERE Name = '" + GetGadgetText(cmbShape) + "';") 
      FirstDatabaseRow(Main::ShapesDB)
      ShapeID = GetDatabaseLong(Main::ShapesDB, DatabaseColumnIndex(Main::ShapesDB, "ShapeID"))
    EndIf
  EndIf    

  ProcedureReturn ShapeID

EndProcedure

  Procedure.i Open()

    dlgLoadShape = OpenWindow(#PB_Any, 0, 0, 250, 80, "Load Shape", #PB_Window_WindowCentered)
  
    OldGadgetList = UseGadgetList(WindowID(dlgLoadShape))
    txtSelectIcon = TextGadget(#PB_Any, 10, 10, 70, 20, "Select Shape", #PB_Text_Right)
    cmbShape = ComboBoxGadget(#PB_Any, 90, 10, 150, 20)
    btnOk = ButtonGadget(#PB_Any, 120, 40, 50, 30, "Ok")
    DisableGadget(btnOk, #True)
    btnCancel = ButtonGadget(#PB_Any, 190, 40, 50, 30, "Cancel")
    UseGadgetList(OldGadgetList)
    
    LoadShapescmb()
    
    Repeat
  
      Event = WaitWindowEvent()
      
      Select Event
       
        Case #PB_Event_Gadget
      
          Select EventGadget()
          
            Case cmbShape
          
              If GetGadgetText(cmbShape) = ""
                DisableGadget(cmbShape, 1)   
                DisableGadget(btnOk, #True)             
              Else
                DisableGadget(btnOk, #False)
              EndIf
          
            Case btnOk
          
              OkPressed = #True
              Main::CurrentShape = GetGadgetText(cmbShape)
              Main::SelectedShapeID = GetShapeID()
              CloseWindow(dlgLoadShape)        
              Break
          
            Case btnCancel
          
              Main::CurrentShape = ""
              CloseWindow(dlgLoadShape)
              Break
          
          EndSelect ;EventGadget()
      
      EndSelect ;Event
  
    ForEver

  EndProcedure

EndModule
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 76
; FirstLine = 48
; Folding = v-
; EnableXP