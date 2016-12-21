;{ ==Code Header Comment==============================
;        Name/title: DrawCircle.pbi
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
;       Description: Module to handle drawing of circles on main form canvas
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule DrawCircle

  Declare NewCircle()
  Declare Defaults()
  
EndDeclareModule

Module DrawCircle

  Global strStartX.i, strStartY.i, strRadius.i, optFill.i, optOutLine.i, btnDone.i

  Global spnThickness
    
  Global Thickness.i
    
  Global DrawAction.i = -1    
  
  Procedure Process(x.i,y.i)
    
    Main::NewObject\Colour = Main::SelectedColour
    
    Select DrawAction
            
      Case 0
        ;No Action 
            
      Case 1
        
  
        If StartVectorDrawing(CanvasVectorOutput(Main::drgCanvas))
          ;Clearcanvas
          DrawVectorImage(ImageID(Main::DrawnImg), 255)
          Main::DrawCircle(Main::NewObject)
          Main::FinishPath(Main::NewObject)
          StopVectorDrawing()   
       EndIf  
            
    EndSelect
    
  EndProcedure
  
  Procedure DrawCircle()
    
    Done = #False

    Repeat
  
      Event = WaitWindowEvent()
      Used = #False
      
      Select Event
        Case #PB_Event_Gadget
          Select EventGadget()
              
            Case Main::drgCanvas
              Used = #True
              ;Snap To grid
              X = Round((GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_MouseX)/5) ,#PB_Round_Nearest) * 5
              Y = Round((GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_MouseY)/5),#PB_Round_Nearest) * 5
              If X < 0
                X = 0
              ElseIf X > 640
                X = 640
              EndIf
              If Y < 0
                Y = 0
              ElseIf Y > 640
                Y = 640
              EndIf
          
              Select EventType()
          
                Case #PB_EventType_LeftClick
                  
                Select Drawaction
                    
                  Case 0 
                    
                    ;First Mouse Click Set Centre Point
                    Main::NewObject\X1 = X/5
                    Main::NewObject\Y1 = Y/5
                    SetGadgetText(Main::#strX1,Str(Main::NewObject\X1/5))      
                    SetGadgetText(Main::#strY1,Str(Main::NewObject\Y1/5))                   
                    Drawaction = Drawaction + 1
              
                  Case 1
 
                    ;Second Click Set End Point
                    Drawaction = Drawaction + 1
                    Main::Drawmode = "Idle"                    
                    Main::SaveElement("Circle")
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
                      Main::NewObject\RadiusX = (Sqr(Pow(((Main::NewObject\X1 * 5) - X ),2) + Pow(((Main::NewObject\Y1 * 5) - Y),2)))/5           
                      SetGadgetText(Main::#strRadiusX,Str(Main::NewObject\RadiusX/5))                    
                      Process(x,y) 
  

                  EndSelect ;Drawaction
                  
                EndIf
              
              EndSelect ;EventType()   
              
          EndSelect ;EventGadget()
      
      EndSelect ;Event
        
    Until Done = #True  
    
  EndProcedure   
  
  Procedure GrabDrawnImage()
       
    ;Create Drawn Image 
    Main::DrawnImg = CreateImage(#PB_Any, 640,640, 32)
    If StartDrawing(ImageOutput(Main::DrawnImg))
      DrawImage(GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_Image), 0, 0)
      StopDrawing()
    EndIf

EndProcedure
  
  Procedure NewCircle()

  ;Start the drawing operation
  ;Get the image drawn so far
  GrabDrawnImage() 
  Drawaction = 0
  DrawCircle()
  Main::Drawmode = "Idle"

  EndProcedure
    
Procedure Defaults()
  
  ;Set Circle Defaults
  Main::NewObject\Angle1 = 0
  Main::NewObject\Angle2 = 0  
  Main::NewObject\Closed = #False 
  Main::NewObject\Colour = RGBA(0,0,0,255)  
  Main::NewObject\Dash = #False
  Main::NewObject\DashFactor = 1.1 
  Main::NewObject\Dot = #False
  Main::NewObject\DotFactor = 1.1  
  Main::NewObject\Filled = #False
  Main::NewObject\Pathtype = "Circle"  
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
  
EndModule
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 189
; FirstLine = 185
; Folding = --
; EnableXP
; EnableUnicode