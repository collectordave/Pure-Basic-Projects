;{ ==Code Header Comment==============================
;        Name/title: dlgChooseElement.pbi
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
;       Description: Module to alloow a choice of path element
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

EnableExplicit
DeclareModule ChooseElement
  
  Global Type.s
  Global Radius.i, EndPath.i
  Declare.i Open() 
  
EndDeclareModule

Module ChooseElement

  Global dlgChooseElement.i
  Global btnOk, btnEnd, optLine, optArc, spnRadius

Procedure.i Open()

  dlgChooseElement = OpenWindow(#PB_Any, x, y, 200, 130, "Select Element", #PB_Window_TitleBar | #PB_Window_Tool | #PB_Window_WindowCentered)
  optArc = OptionGadget(#PB_Any, 10, 10, 50, 20, "Arc")
  Text_0 = TextGadget(#PB_Any, 80, 10, 50, 20, "Radius")  
  spnRadius = SpinGadget(#PB_Any, 140, 10, 50, 20, 1, 100, #PB_Spin_ReadOnly | #PB_Spin_Numeric)  
  optCurve = OptionGadget(#PB_Any, 10, 40, 70, 20, "Curve")
  optLine = OptionGadget(#PB_Any, 10, 70, 60, 20, "Line")
  btnOk = ButtonGadget(#PB_Any, 30, 100, 50, 20, "Ok")
  btnEnd = ButtonGadget(#PB_Any, 120, 100, 50, 20, "End") 
  
  ;Select Line As default
  SetGadgetState(optLine, 1)

  SetGadgetState(spnRadius,10)
  SetGadgetText(spnRadius,"10")
  DisableGadget(spnRadius, 1)

  StickyWindow(dlgChooseElement,#True)
  EndPath = #False
  
  Repeat
  
    Event = WaitWindowEvent()
    Select Event
      
      Case #PB_Event_Gadget
        Select EventGadget()
          Case  optArc
            If GetGadgetState(optArc)
            DisableGadget(spnRadius, #False)
          Else
             DisableGadget(spnRadius, #True) 
           EndIf 
          Case  optline,optCurve
            If GetGadgetState(optline)
            DisableGadget(spnRadius, #True)
          Else
             DisableGadget(spnRadius, #False) 
           EndIf 
         Case btnOk
           
           If GetGadgetState(optArc)
             ChooseElement::Type = "A"
             ChooseElement::Radius = GetGadgetState(spnRadius)           
           ElseIf GetGadgetState(optCurve)
             ChooseElement::Type = "C"
           ElseIf GetGadgetState(optLine)
             ChooseElement::Type = "L"
           EndIf
           
           CloseWindow(dlgChooseElement)
           Break
           
         Case btnEnd
           
           EndPath = #True          
           CloseWindow(dlgChooseElement)
           Break
           
       EndSelect
      
    EndSelect ;Event
  
  ForEver

EndProcedure

EndModule
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 68
; FirstLine = 79
; Folding = -
; EnableXP