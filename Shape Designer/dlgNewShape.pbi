;{ ==Code Header Comment==============================
;        Name/title: dlgNewShape.pbi
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
;       Description: Module to handle adding new shape to database
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule NewShape
  
  Global OkPressed.i = #False
  
  Global ShapeID.i, Name.s
  
  Declare Open()
  
EndDeclareModule

Module NewShape
  
  Global dlgNewShape.i, strName.i, cmbGroup.i, btnOk.i, btnCancel.i
  
  Procedure SaveShape()
    
    Define Criteria.s
    
    Criteria = "INSERT INTO Shapes (Name)"
    Criteria = Criteria + " VALUES('" + GetGadgetText(strName) + "');"
    DatabaseUpdate(Main::ShapesDB,Criteria) 
      
    ;Get ShapeID
    If DatabaseQuery(Main::ShapesDB, "SELECT * FROM Shapes WHERE Name = '" + GetGadgetText(strName) + "';")
      
      If FirstDatabaseRow(Main::ShapesDB) > 0
        ShapeID = GetDatabaseLong(Main::ShapesDB, 0)
      EndIf
      
      FinishDatabaseQuery(Main::ShapesDB)
      
    EndIf    
      
  EndProcedure
  
   Procedure Open()

    dlgNewShape = OpenWindow(#PB_Any, x, y, 190, 70, "Enter Shape Name", #PB_Window_TitleBar | #PB_Window_Tool | #PB_Window_WindowCentered| #PB_Window_NoGadgets)
    OldGadgetList = UseGadgetList(WindowID(dlgNewShape))  
    strName = StringGadget(#PB_Any, 10, 10, 170, 20, "")
    btnOk = ButtonGadget(#PB_Any, 10, 40, 60, 20, "Ok")
    btnCancel = ButtonGadget(#PB_Any, 120, 40, 60, 20, "Cancel")
    UseGadgetList(OldGadgetList)
    StickyWindow(dlgNewShape,#True)
    
    Repeat
  
      Event = WaitWindowEvent()
    
      If Event = #PB_Event_Gadget
        Select EventGadget()
            
          Case btnOk
            SaveShape()
            Name = GetGadgetText(strName)
            OkPressed = #True
            CloseWindow(dlgNewShape)
            Break

          Case btnCancel
            OkPressed = #False
            CloseWindow(dlgNewShape)            
            Break
            
        EndSelect
        
      EndIf
      
    ForEver
    
  EndProcedure
  
 EndModule   
    
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 61
; FirstLine = 48
; Folding = -
; EnableXP
; EnableUnicode