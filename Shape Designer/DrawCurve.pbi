;{ ==Code Header Comment==============================
;        Name/title: DrawCurve.pbi
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
;       Description: Module to handle drawing of curves on main form canvas
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule DrawCurve
  
  Declare NewCurve()
  Declare defaults()
  
EndDeclareModule

Module DrawCurve

  Global Window_0

  Global strStartX, strStartY, strMidX1, strMidY1, strMidX2, strMidY2, strEndX, strEndY, btnColour
    
  Global Thickness.i,  Transparency.i
  
  Global DrawAction.i = -1   
  
  Procedure Process(x.i,y.i)
    
  Main::NewObject\Colour = Main::SelectedColour  
    
  If StartVectorDrawing(CanvasVectorOutput(Main::drgCanvas))
    
    ;VectorSourceColor(RGBA(0,0,0,255))
    
    ;Clearcanvas
    DrawVectorImage(ImageID(Main::DrawnImg), 255)
     
        Select DrawAction
            
          Case 0 ;Start Point
            
            Main::NewObject\X1 = X/5
            Main::NewObject\Y1 = Y/5
            ;Set all to allow curve to be drawn
            Main::NewObject\X2 = X/5
            Main::NewObject\Y2 = Y/5           
            Main::NewObject\X3 = X/5
            Main::NewObject\Y3 = Y/5
            
          Case 1 ;EndPoint
            
            Main::NewObject\X4 = X/5
            Main::NewObject\Y4 = Y/5
            Main::DrawCurve(Main::NewObject)

          Case 2 ;Control Point 1
            
            Main::NewObject\X2 = X/5
            Main::NewObject\Y2 = Y/5
            Main::DrawCurve(Main::NewObject)           
 
          Case 3 ;Control Point 2
            
            Main::NewObject\X3 = X/5
            Main::NewObject\Y3 = Y/5
            Main::DrawCurve(Main::NewObject)
            
      EndSelect

    StopVectorDrawing()

  EndIf
    
  EndProcedure
  
  Procedure GrabDrawnImage()
       
    ;Create Drawn Image 
    Main::DrawnImg = CreateImage(#PB_Any, 640,640, 32)
    If StartDrawing(ImageOutput(Main::DrawnImg))
      DrawImage(GetGadgetAttribute(Main::drgCanvas, #PB_Canvas_Image), 0, 0)
      StopDrawing()
    EndIf

  EndProcedure 
  
  Procedure DrawCurve()
    
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
                  
                  If Drawaction < 4
                    Process(x,y)
                    Drawaction = Drawaction + 1 
                  EndIf
                  If Drawaction = 4
                    Main::Drawmode = "Idle"                    
                    Main::SaveElement("Curve")
                    Done = #True                
                  EndIf
              
                Case #PB_EventType_MouseMove
              
                  Select Drawaction
                    Case 0
                      SetGadgetText(Main::#strX1,Str(X/5))      
                      SetGadgetText(Main::#strY1,Str(Y/5))  
                    Case 1 
                      SetGadgetText(Main::#strX4,Str(X/5))      
                      SetGadgetText(Main::#strY4,Str(Y/5))  
                      Process(x,y)   
                    Case 2 
                      SetGadgetText(Main::#strX2,Str(X/5))      
                      SetGadgetText(Main::#strY2,Str(Y/5))  
                      Process(x,y)              
                    Case 3 
                      SetGadgetText(Main::#strX3,Str(X/5))      
                      SetGadgetText(Main::#strY3,Str(Y/5))  
                      Process(x,y) 
 
                    Case 4
                      ;Main::Drawmode = "Idle"                    
                     ; Main::SaveElement("Curve")
                      ;Done = #True                     
                  EndSelect 
              
              EndSelect ;EventType()   
              
          EndSelect
      
      EndSelect
        
    Until Done = #True 
    
    
  EndProcedure
  
  Procedure NewCurve()

  ;Start the drawing operation
  ;Get the image drawn so far
  GrabDrawnImage() 
  Drawaction = 0
  DrawCurve()

  Main::Drawmode = "Idle"

  EndProcedure
  
Procedure Defaults()
  
  ;Set Curve Defaults
  Main::NewObject\Angle1 = 0
  Main::NewObject\Angle2 = 0  
  Main::NewObject\Closed = #False 
  Main::NewObject\Colour = RGBA(0,0,0,255)  
  Main::NewObject\Dash = #False
  Main::NewObject\DashFactor = 1.1 
  Main::NewObject\Dot = #False
  Main::NewObject\DotFactor = 1.1  
  Main::NewObject\Filled = #False
  Main::NewObject\Pathtype = "Curve"  
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
; CursorPosition = 204
; FirstLine = 200
; Folding = --
; EnableXP
; EnableUnicode