;{ ==Code Header Comment==============================
;        Name/title: DrawArc.pbi
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
;       Description: Module to handle drawing of arcs on main form canvas
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule DrawArc
  
 Declare NewArc()
 Declare Defaults()
  
EndDeclareModule

Module DrawArc

  Global Window_0

  Global spnSize, btnColour
    
  Global Thickness.i, Transparency.i
  
  Global DrawAction.i = -1    
 
  Procedure Process(x.i,y.i)

    Static CentreX.i,CentreY.i,Radius.i,Angle1.i,Angle2.i 
    
    Main::NewObject\Colour = Main::SelectedColour   
    
    If StartVectorDrawing(CanvasVectorOutput(Main::drgCanvas))

      ;Clearcanvas to the drawn image
      DrawVectorImage(ImageID(Main::DrawnImg), 255)

      Select DrawAction
        Case 0
            
          CentreX = X
          CentreY = Y 
            
        Case 1 ;Intersect Point Chosen so chose radius and centre point
          
          Main::NewObject\RadiusX = (Sqr(Pow((CentreX-X),2) + Pow((CentreY-Y),2)))/5
          VectorSourceColor(RGBA($FF,$00,$00,$FF))
          AddPathCircle(X,Y, Main::NewObject\RadiusX * 5 , 0,360)
          DashPath(1, 5)        

        Case 2 ;Start Point And radius now get start Angle
     
          VectorSourceColor(RGBA($00,$FF,$00,$FF))
          AddPathCircle(Main::NewObject\X1 * 5,Main::NewObject\Y1 * 5, Main::NewObject\RadiusX * 5 , 0,360)     
          StrokePath(1)   
            
          ;Show Chose angle line           
          VectorSourceColor(RGBA($FF,$00,$00,$FF))
          MovePathCursor(Main::NewObject\X1 * 5,Main::NewObject\Y1 * 5)
          AddPathLine(x,y)
          DashPath(1, 5)
            
          If x => Main::NewObject\X1 * 5 And Y => Main::NewObject\Y1 * 5
            If X - Main::NewObject\X1 * 5 = 0
              Angle1 = 90
            Else
              Angle1 = Degree(ATan((Y - Main::NewObject\Y1 * 5)/(X - Main::NewObject\X1 * 5)))
            EndIf
          ElseIf  x =< Main::NewObject\X1 * 5 And Y => Main::NewObject\Y1 * 5
            If Y-Main::NewObject\Y1 * 5 = 0
              Angle1 = 180
            Else
              Angle1 = 90 + Degree(ATan((Main::NewObject\X1 * 5 - X)/(Y - Main::NewObject\Y1 * 5)))
            EndIf
          ElseIf  x =< Main::NewObject\X1 * 5 And Y =< Main::NewObject\Y1 * 5
            If X - Main::NewObject\X1 * 5 = 0
              Angle1 = 270
            Else
              Angle1 = 180 + Degree(ATan((Y - Main::NewObject\Y1 * 5)/(X - Main::NewObject\X1 * 5)))
            EndIf
          ElseIf  x => Main::NewObject\X1 * 5 And Y =< Main::NewObject\Y1 * 5
            Angle1 = 270 + Degree(ATan((X - Main::NewObject\X1 * 5)/(Main::NewObject\Y1 * 5 - Y)))
          EndIf
          Main::NewObject\Angle1 = Angle1
            
        Case 3 ;Get End Angle
            
          VectorSourceColor(RGBA($00,$FF,$00,$FF))
          AddPathCircle(Main::NewObject\X1 * 5,Main::NewObject\Y1 * 5, Main::NewObject\RadiusX * 5, 0,360)     
          StrokePath(1) 
            
          ;Show Chose angle line           
          VectorSourceColor(RGBA($FF,$00,$00,$FF))
          MovePathCursor(Main::NewObject\X1 * 5,Main::NewObject\Y1 * 5)
          AddPathLine(x,y)
          DashPath(1, 5)
            
          If x => Main::NewObject\X1 * 5 And Y => Main::NewObject\Y1 * 5
            If X - Main::NewObject\X1 * 5 = 0
              Angle2 = 90
            Else
              Angle2 = Degree(ATan((Y - Main::NewObject\Y1 * 5)/(X - Main::NewObject\X1 * 5)))
            EndIf
          ElseIf  x =< Main::NewObject\X1 * 5 And Y => Main::NewObject\Y1 * 5
            If Y-Main::NewObject\Y1 * 5 = 0
              Angle2 = 180
            Else
              Angle2 = 90 + Degree(ATan((Main::NewObject\X1 * 5 - X)/(Y - Main::NewObject\Y1 * 5)))
            EndIf
          ElseIf  x =< Main::NewObject\X1 * 5 And Y =< Main::NewObject\Y1 * 5
            If X - Main::NewObject\X1 * 5 = 0
              Angle2 = 270
            Else
              Angle2 = 180 + Degree(ATan((Y - Main::NewObject\Y1 * 5)/(X - Main::NewObject\X1 * 5)))
            EndIf
          ElseIf  x => Main::NewObject\X1 * 5 And Y =< Main::NewObject\Y1 * 5
            Angle2 = 270 + Degree(ATan((X - Main::NewObject\X1 * 5)/(Main::NewObject\Y1 * 5 - Y)))
          EndIf
          Main::NewObject\Angle2 = Angle2
          Main::DrawArc(Main::NewObject)
            
        Case 4 ;Clean Up

          DrawVectorImage(ImageID(Main::DrawnImg), 255)
          Main::DrawArc(Main::NewObject)        
      
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
 
  Procedure DrawArc()
 
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
                      
                    Case 0  ;Start Point

                      Process(x,y)
                      
                    Case 1 ;Radius
                      
                      Main::NewObject\X1 = X/5
                      Main::NewObject\Y1 = Y/5
                      SetGadgetText(Main::#strX1,Str(Main::NewObject\X1))      
                      SetGadgetText(Main::#strY1,Str(Main::NewObject\Y1))                        
                      Process(x,y)
                      
                    Case 2
                      
                      Process(x,y)
                   
                    Case 3
                      
                      Drawaction = Drawaction + 1
                      Process(x,y)
                      Main::Drawmode = "Idle"                    
                      Main::SaveElement("Arc")
                      Done = #True
                      
                  EndSelect
                  
                  Drawaction = Drawaction + 1
                  
                Case #PB_EventType_MouseMove
              
                  Select Drawaction
                    Case 0
                      SetGadgetText(Main::#strX1,Str(X/5))      
                      SetGadgetText(Main::#strY1,Str(Y/5))  
                    Case 1 
                      SetGadgetText(Main::#strRadiusX,Str(Main::NewObject\RadiusX))      
                      Process(x,y)  
                    Case 2
                      SetGadgetText(Main::#spnAngle1,Str(Main::NewObject\Angle1))   
                      Process(x,y)                     
                    Case 3
                      SetGadgetText(Main::#spnAngle2,Str(Main::NewObject\Angle2))   
                      Process(x,y) 
                    Case 4
                      Process(x,y)
                  EndSelect  
              
              EndSelect ;EventType()   
              
          EndSelect
      
      EndSelect
        
    Until Done = #True 

  EndProcedure
 
  Procedure NewArc()

    GrabDrawnImage() 
    Drawaction = 0
    DrawArc()
    Main::Drawmode = "Idle"
    
  EndProcedure
    
Procedure Defaults()
  
  ;Set Arc Defaults
  Main::NewObject\Angle1 = 0
  Main::NewObject\Angle2 = 0  
  Main::NewObject\Closed = #False 
  Main::NewObject\Colour = RGBA(0,0,0,255)  
  Main::NewObject\Dash = #False
  Main::NewObject\DashFactor = 1.1 
  Main::NewObject\Dot = #False
  Main::NewObject\DotFactor = 1.1  
  Main::NewObject\Filled = #False
  Main::NewObject\Pathtype = "Arc"  
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
; CursorPosition = 273
; FirstLine = 239
; Folding = +-
; EnableXP
; EnableUnicode