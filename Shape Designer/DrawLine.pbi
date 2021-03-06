﻿;{ ==Code Header Comment==============================
;        Name/title: DrawLine.pbi
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
;       Description: Module to handle drawing of lines on main form canvas
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule DrawLine
  
  Declare NewLine()
  Declare Defaults()
  
EndDeclareModule

Module DrawLine
  
  Global Accept.i = #True
  
  Global strStartX.i, strStartY.i, strEndX.i, strEndY.i, spnThickness.i, btnDone.i
  
  Global DrawAction.i = -1
  
  Global TestRound.i = #True
  
Procedure Process(x.i,y.i)
  
    Main::NewObject\Colour = Main::SelectedColour
  
    Select DrawAction
            
      Case 0
        ;No Action 
            
      Case 1
        
        ;Clear Canvas      
        StartDrawing(CanvasOutput(Main::drgCanvas))
        DrawImage(ImageID(Main::DrawnImg), 0, 0)
        StopDrawing()          
        If StartVectorDrawing(CanvasVectorOutput(Main::drgCanvas))
          Main::NewObject\X2 = X / 5
          Main::NewObject\Y2 = Y / 5
          Main::DrawLine(Main::NewObject)
          StopVectorDrawing()   
        EndIf  
            
    EndSelect

  EndProcedure
  
Procedure DrawLine()
  
  Done = #False
  Static OldX.i,OldY.i
  
  Repeat
  
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
              
          Case Main::drgCanvas
            
            ;Snap To grid
            X = Round((GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_MouseX)/5) ,#PB_Round_Nearest) * 5
            Y = Round((GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_MouseY)/5),#PB_Round_Nearest) * 5
            If X < 0
              
              X = 0
              
            ElseIf X > 500
              
              X = 500
              
            EndIf
            If Y < 0
              
              Y = 0
              
            ElseIf Y > 500
              
              Y = 500
              
            EndIf

            Select EventType()
                
                
              Case #PB_EventType_LeftClick

                Select Drawaction
                    
                  Case 0 
                    
                    ;First Mouse Click Set Start Point
                    Main::NewObject\X1 = X/5
                    Main::NewObject\Y1 = Y/5
                    SetGadgetText(Main::#strX1,Str(Main::NewObject\X1))      
                    SetGadgetText(Main::#strY1,Str(Main::NewObject\Y1))                   
                    Drawaction = Drawaction + 1
              
                  Case 1
                    
                    ;Second Click Set End Point
                    Main::NewObject\X2 = X/5
                    Main::NewObject\Y2 = Y/5
                    Drawaction = Drawaction + 1
                    Main::Drawmode = "Idle"                    
                    Main::SaveElement("Line")
                    Done = #True 
                    
                EndSelect
                
              Case #PB_EventType_MouseMove
                
                ;Only on significant move
                If (x <> OldX) Or (y <> OldY) 
                  
                  OldX = x
                  OldY = y
                  
                  Select Drawaction
                      
                    Case 0
                      
                      ;Show Start Point Dynamic
                      SetGadgetText(Main::#strX1,Str(X/5))      
                      SetGadgetText(Main::#strY1,Str(Y/5))  
                      
                    Case 1 
                      
                      Process(x,y) 
                      SetGadgetText(Main::#strX2,Str(X/5))      
                      SetGadgetText(Main::#strY2,Str(Y/5))  

                  EndSelect ;Drawaction
                  
                EndIf
                
            EndSelect  ;EventType()   
            
        EndSelect  ;EventGadget()
        
    EndSelect  ;Event 
   
  Until Done = #True
  
  
EndProcedure
  
Procedure GrabDrawnImage()
       
    ;Create Drawn Image 
    Main::DrawnImg = CreateImage(#PB_Any, 500,500, 32)
    If StartDrawing(ImageOutput(Main::DrawnImg))
      DrawImage(GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_Image), 0, 0)
      StopDrawing()
    EndIf

EndProcedure

Procedure Defaults()
  
  ;Set Line Defaults
  Main::NewObject\Angle1 = 0
  Main::NewObject\Angle2 = 0  
  Main::NewObject\Closed = #False 
  Main::NewObject\Colour = RGBA(0,0,0,255)  
  Main::NewObject\Dash = #False
  Main::NewObject\DashFactor = 1.1 
  Main::NewObject\Dot = #False
  Main::NewObject\DotFactor = 1.1  
  Main::NewObject\Filled = #False
  Main::NewObject\Pathtype = "Line"  
  Main::NewObject\Points = 0
  Main::NewObject\RadiusX = 0
  Main::NewObject\RadiusY = 0
  Main::NewObject\Rotation = 0
  Main::NewObject\Rounded = #False  
  Main::NewObject\Stroke = #True  
  Main::NewObject\Text = ""
  Main::NewObject\Trans = 255
  Main::NewObject\Width = 1
  Main::NewObject\X1 = 0
  Main::NewObject\Y1 = 0  
  Main::NewObject\X2 = 0  
  Main::NewObject\Y2 = 0  
  Main::NewObject\X3 = 0
  Main::NewObject\Y3 = 0  
  Main::NewObject\X4 = 0  
  Main::NewObject\Y4 = 0   
  
  ;Show Defaults
  Main::ShowElement(Main::NewObject)
  
EndProcedure

Procedure NewLine()

  GrabDrawnImage()
  Drawaction = 0
  DrawLine()
  Main::Drawmode = "Idle"

EndProcedure

EndModule

; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 117
; FirstLine = 103
; Folding = --
; EnableXP
; EnableUnicode