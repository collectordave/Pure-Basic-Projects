
Global Window_0.i,txtToolTip.i

Global Canvas_0

Global Dim DrawTips.s(10)

DrawTips(0) = "Select Start Point"
DrawTips(1) = "Select End Point"
DrawTips(2) = "Select Arc Intersect"
DrawTips(3) = "Select Radius"
Procedure SetTip(TipNo.i)
  
  SetGadgetText(txtToolTip,DrawTips(TipNo))
  
  ;Select TipNo
      
  ;  Case 0
  ;    ResizeGadget(ToolTip,#PB_Ignore,#PB_Ignore,50,#PB_Ignore)
   ;  Case 1
   ;    ResizeGadget(ToolTip,#PB_Ignore,#PB_Ignore,50,#PB_Ignore)
   ;   EndSelect
EndProcedure




  Window_0 = OpenWindow(#PB_Any, 0, 0, 600, 400, "", #PB_Window_SystemMenu)
  Canvas_0 = CanvasGadget(#PB_Any, 80, 70, 300, 200)
  txtToolTip = TextGadget(#PB_Any, 10, 10, 50, 30, "My third ToolTip") 
  SetGadgetColor(txtToolTip, #PB_Gadget_BackColor,RGB(255,255,255))   
  HideGadget(txtToolTip,#True)
  
  settip(0)

  i = 0
  
  
  Repeat
    
    event = WaitWindowEvent()
    
      Select event
    Case #PB_Event_CloseWindow
      End

    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
        Case Canvas_0
          HideGadget(txtToolTip,#False)
          Select EventType()
            Case #PB_EventType_MouseMove
              x = GetGadgetAttribute(Canvas_0, #PB_Canvas_MouseX)
              y = GetGadgetAttribute(Canvas_0, #PB_Canvas_MouseY)            
              If (x + 50) < 300
                x = x + 85
              Else
                x  = 250 + 80
              EndIf
              If y < 30
                y = 30 + 45
              Else
                y = y + 45
              EndIf
              
        
               ResizeGadget(txtToolTip,x,y,#PB_Ignore,#PB_Ignore)
               
             Case #PB_EventType_LeftClick
               i = i + 1
               If i > 3
                 i = 0
               EndIf
               
               settip(i)
               ;SetGadgetText(Tooltip,"Tip " + Str(i))
            Case #PB_EventType_MouseLeave
             HideGadget(txtToolTip,#True)
          EndSelect
      EndSelect
      

  EndSelect
  
  ForEver
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 81
; FirstLine = 63
; Folding = -
; EnableXP