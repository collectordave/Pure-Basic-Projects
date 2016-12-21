;{ ==Code Header Comment==============================
;        Name/title: dlgEditPath.pbi
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
;       Description: Module to edit paths
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

EnableExplicit
DeclareModule editPath
  
  Declare.s Open(PathString.s)
  
EndDeclareModule

Module editPath

  Structure Element
    Type.i
    x1.i
    y1.i
    x2.i
    y2.i
    x3.i
    y3.i
  EndStructure
  
  Global NumberOfElements.i = 0
  Global Dim Pathctls.Element(0)
  Global Dim PathStr.s(4)
  
Procedure.s Open(PathString.s)

  Dim Args.i(5)
  Define NumArgs.i
  Define OutPutString.s = ""
  
  Define dlgEditPath,btnOk,btnCancel
  
  NumberOfElements = 0  
  
  dlgEditPath = OpenWindow(#PB_Any, 0, 0, 400, 100, "Path Editor", #PB_Window_SystemMenu)
  
  For i = 1 To CountString(PathString, ",") + 1
    
    Select StringField(PathString, i, ",")
        
      Case "M"
        
        NumArgs = 0
        i = i + 1
        Args(NumArgs) = Val(StringField(PathString, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1
        Args(NumArgs) = Val(StringField(PathString, i, ","))       
        Pathctls(NumberOfElements)\Type = TextGadget(#PB_Any, 10, 30 + NumberOfElements * 30, 70, 20, "Start")
        Pathctls(NumberOfElements)\x1 = StringGadget(#PB_Any, 100, 30 + NumberOfElements * 30, 40, 20, Str(Args(0)))
        GadgetToolTip(Pathctls(NumberOfElements)\x1, "Start Point X Coordinate")         
        Pathctls(NumberOfElements)\y1  = StringGadget(#PB_Any, 150, 30 + NumberOfElements * 30, 40, 20, Str(args(1)))
        GadgetToolTip(Pathctls(NumberOfElements)\y1, "Start Point Y Coordinate")         
        NumberOfElements = NumberOfElements + 1
        
      Case "A"
        
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
       
        i = i + 1
        NumArgs = NumArgs + 1        
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
     
        i = i + 1
        NumArgs = NumArgs + 1         
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
     
       i = i + 1
       NumArgs = NumArgs + 1 
       Args.i(NumArgs) = Val(StringField(PathString, i, ","))
       i = i + 1
       NumArgs = NumArgs + 1 
       Args.i(NumArgs) = Val(StringField(PathString, i, ","))
       Pathctls(NumberOfElements)\Type = TextGadget(#PB_Any, 10, 30 + NumberOfElements * 30, 70, 20, "Arc")
       Pathctls(NumberOfElements)\x1 = StringGadget(#PB_Any, 100, 30 + NumberOfElements * 30, 40, 20, Str(Args(0)))
       GadgetToolTip(Pathctls(NumberOfElements)\x1, "Line Direction X Coordinate")        
       Pathctls(NumberOfElements)\y1  = StringGadget(#PB_Any, 150, 30 + NumberOfElements * 30, 40, 20, Str(Args(1)))     
       GadgetToolTip(Pathctls(NumberOfElements)\y1, "Line Direction Y Coordinate")          
       Pathctls(NumberOfElements)\x2 = StringGadget(#PB_Any, 200, 30 + NumberOfElements * 30, 40, 20, Str(Args(2)))
       GadgetToolTip(Pathctls(NumberOfElements)\x2, "Arc Direction X Coordinate")       
       Pathctls(NumberOfElements)\y2 = StringGadget(#PB_Any, 250, 30 + NumberOfElements * 30, 40, 20, Str(Args(3)))         
       GadgetToolTip(Pathctls(NumberOfElements)\y2, "Arc Direction Y Coordinate")      
       Pathctls(NumberOfElements)\x3  = StringGadget(#PB_Any, 300, 30 + NumberOfElements * 30, 40, 20, Str(Args(4))) 
       GadgetToolTip(Pathctls(NumberOfElements)\x3, "Radius")      
       NumberOfElements = NumberOfElements + 1 
           
       
      Case "C"
        
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
       
        i = i + 1
        NumArgs = NumArgs + 1        
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
     
        i = i + 1
        NumArgs = NumArgs + 1         
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
     
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
        
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))       
        
        i = i + 1
        NumArgs = NumArgs + 1 
        
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
        Pathctls(NumberOfElements)\Type = TextGadget(#PB_Any, 10, 30 + NumberOfElements * 30, 70, 20, "Curve")
        Pathctls(NumberOfElements)\x1 = StringGadget(#PB_Any, 100, 30 + NumberOfElements * 30, 40, 20, Str(Args(0)))
        GadgetToolTip(Pathctls(NumberOfElements)\x1, "Control Point 1 X Coordinate")       
        Pathctls(NumberOfElements)\y1  = StringGadget(#PB_Any, 150, 30 + NumberOfElements * 30, 40, 20, Str(Args(1)))     
        GadgetToolTip(Pathctls(NumberOfElements)\y1, "Control Point 1 Y Coordinate")           
        Pathctls(NumberOfElements)\x2 = StringGadget(#PB_Any, 200, 30 + NumberOfElements * 30, 40, 20, Str(Args(2)))
         GadgetToolTip(Pathctls(NumberOfElements)\x2, "Control Point 2 X Coordinate")          
        Pathctls(NumberOfElements)\y2 = StringGadget(#PB_Any, 250, 30 + NumberOfElements * 30, 40, 20, Str(Args(3)))         
         GadgetToolTip(Pathctls(NumberOfElements)\y2, "Control Point 2 Y Coordinate")          
        Pathctls(NumberOfElements)\x3  = StringGadget(#PB_Any, 300, 30 + NumberOfElements * 30, 40, 20, Str(Args(4))) 
        GadgetToolTip(Pathctls(NumberOfElements)\x3, "End Point X Coordinate")        
        Pathctls(NumberOfElements)\y3  = StringGadget(#PB_Any, 350, 30 + NumberOfElements * 30, 40, 20, Str(Args(5)))      
        GadgetToolTip(Pathctls(NumberOfElements)\y3, "End Point Y Coordinate")        
        NumberOfElements = NumberOfElements + 1       
       
     Case "L"
        
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))
        NumArgs = NumArgs + 1         
        i = i + 1
        Args.i(NumArgs) = Val(StringField(PathString, i, ","))         
        Pathctls(NumberOfElements)\Type = TextGadget(#PB_Any, 10, 30 + NumberOfElements * 30, 70, 20, "Line")
        Pathctls(NumberOfElements)\x1 = StringGadget(#PB_Any, 100, 30 + NumberOfElements * 30, 40, 20, Str(Args(0)))
        GadgetToolTip(Pathctls(NumberOfElements)\x1, "End Point X Coordinate")       
        Pathctls(NumberOfElements)\y1  = StringGadget(#PB_Any, 150, 30 + NumberOfElements * 30, 40, 20, Str(Args(1)))
        GadgetToolTip(Pathctls(NumberOfElements)\y1, "End Point Y Coordinate")        
        NumberOfElements = NumberOfElements + 1       
       
       
     Case "Z"
       ;Do Nothing Set In Main Routine
       
   EndSelect   
   
   ReDim Pathctls(NumberOfElements)
   
  Next i
  
  btnOk = ButtonGadget(#PB_Any, 170, 30 + NumberOfElements * 30, 80, 30, "Ok")
  btnCancel = ButtonGadget(#PB_Any, 260, 30 + NumberOfElements * 30, 80, 30, "Cancel")  
  ResizeWindow(dlgEditPath, #PB_Ignore, #PB_Ignore, #PB_Ignore, (30 + NumberOfElements * 30) + 40) 
  StickyWindow(dlgEditPath,#True)
  
  Repeat
    
    Event = WaitWindowEvent()
    Select event
        
      Case #PB_Event_CloseWindow
        CloseWindow(dlgEditPath)
        OutPutString = PathString
        Break
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case btnOk
            
            OutPutString = ""
            For iLoop = 0 To NumberOfElements - 1
              Select GetGadgetText(Pathctls(iLoop)\Type)
                Case "Start"
                  OutPutString = "M," + GetGadgetText(Pathctls(iLoop)\x1) + "," + GetGadgetText(Pathctls(iLoop)\y1) + ","
                Case "Arc"
                   OutPutString = OutPutString + "A," + GetGadgetText(Pathctls(iLoop)\x1) + "," + GetGadgetText(Pathctls(iLoop)\y1) + "," + GetGadgetText(Pathctls(iLoop)\x2) + "," + GetGadgetText(Pathctls(iLoop)\y2) + "," + GetGadgetText(Pathctls(iLoop)\x3) + ","
                Case "Curve"
                   OutPutString = OutPutString + "C," + GetGadgetText(Pathctls(iLoop)\x1) + "," + GetGadgetText(Pathctls(iLoop)\y1) + "," + GetGadgetText(Pathctls(iLoop)\x2) + "," + GetGadgetText(Pathctls(iLoop)\y2) + "," + GetGadgetText(Pathctls(iLoop)\x3) + "," + GetGadgetText(Pathctls(iLoop)\y3) +","
                Case "Line"
                  OutPutString = OutPutString + "L," + GetGadgetText(Pathctls(iLoop)\x1) + "," + GetGadgetText(Pathctls(iLoop)\y1) + ","
              EndSelect
           Next iLoop
           ;Remove Last Comma          
           OutPutString = Left(OutPutString,Len(OutPutString)-1)
           CloseWindow(dlgEditPath)
           Break
           
         Case btnCancel
           
           CloseWindow(dlgEditPath)
           OutPutString = PathString
           Break
            
        EndSelect
      
  EndSelect 

ForEver

ProcedureReturn OutPutString

EndProcedure

EndModule
  
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 146
; FirstLine = 146
; Folding = -
; EnableXP