;{ ==Code Header Comment==============================
;        Name/title: DrawPath.pbi
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
;       Description: Module to handle drawing of Paths on main form canvas
; ====================================================
;.......10........20........30........40........50........60........70........80
;}

DeclareModule DrawPath
  
  Declare NewPath()
  Declare Defaults()
  
EndDeclareModule

Module DrawPath
  
  ;Structure Array to hold path data  
  Structure Location
    Type.s
    Arg1.i
    Arg2.i
    Arg3.i
    Arg4.i
    Arg5.i
    Arg6.i
  EndStructure
  Global Dim PathPoints.location(0)   
   
  Global DrawElement.i = -1
  Global CurrentAction.i,AntiClock.i = #False
  Global Accept.i = #True
  
  Global PathString.s
  Global IntersectX.i,IntersectY.i,ArcRadius.i
  Global strStartX.i, strStartY.i, spnThickness.i, btnDone.i
    
  Global TestRound.i = #True
  
    Procedure SavePath()
    
    Define DrawText.s = ""
    
    For iLoop = 0 To ArraySize(PathPoints())
      Select   PathPoints(iLoop)\Type
        Case "M"
          DrawText = "M," + Str(PathPoints(iLoop)\Arg1) + "," + Str(PathPoints(iLoop)\Arg2)      
        Case "L"
          DrawText = DrawText + ",L," + Str(PathPoints(iLoop)\Arg1) + "," + Str(PathPoints(iLoop)\Arg2)   
        Case "A"  
          DrawText = DrawText + ",A," + Str(PathPoints(iLoop)\Arg1) + "," + Str(PathPoints(iLoop)\Arg2) + "," + Str(PathPoints(iLoop)\Arg3) + "," + Str(PathPoints(iLoop)\Arg4) + "," + Str(PathPoints(iLoop)\Arg5)
         Case "C"  
          DrawText = DrawText + ",C," + Str(PathPoints(iLoop)\Arg1) + "," + Str(PathPoints(iLoop)\Arg2) + "," + Str(PathPoints(iLoop)\Arg3) + "," + Str(PathPoints(iLoop)\Arg4) + "," + Str(PathPoints(iLoop)\Arg5) + "," + Str(PathPoints(iLoop)\Arg6)
      EndSelect    
    Next
    If GetGadgetState(Main::#optClosed)
      DrawText = DrawText + ",Z"
    EndIf
    
    Main::NewObject\Text = DrawText

  EndProcedure

  Procedure Process(x.i,y.i)
    
    Main::NewObject\Colour = Main::SelectedColour
    
    If StartVectorDrawing(CanvasVectorOutput(Main::drgCanvas))
      ;Clear Canvas      
      StartDrawing(CanvasOutput(Main::drgCanvas))
        DrawImage(ImageID(Main::DrawnImg), 0, 0)
      StopDrawing()  
      
      SavePath()
      Main::DrawPath(Main::NewObject)

      StopVectorDrawing()    

    EndIf

  EndProcedure

  Procedure DrawPath()
  
    Done = #False
    Static OldX.i,OldY.i
    Protected ThisPath.s
    
    CurrentAction = -1
  
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
                
                  Select CurrentAction
                    Case -1
                      ;First Mouse Click Move To Path Start Point
                      PathPoints(DrawElement)\Type = "M"
                      PathPoints(DrawElement)\Arg1 = X/5
                      PathPoints(DrawElement)\Arg2 = Y/5
                      DrawElement = DrawElement + 1
                      ReDim  PathPoints(DrawElement)
                    
                      ChooseElement::Open()
                      If ChooseElement::EndPath = #True
                        Main::Drawmode = "Idle"                    
                        Main::SaveElement("Path")  
                        Done = #True       
                      Else
                        PathPoints(DrawElement)\Type = ChooseElement::Type
                      
                        Select ChooseElement::Type
                          
                          Case "A"

                            ;Radius Of vectorArc
                            ArcRadius = ChooseElement::Radius  * 5
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5                       
                            PathPoints(DrawElement)\Arg3 = 0
                            PathPoints(DrawElement)\Arg4 = 0
                            PathPoints(DrawElement)\Arg5 = 0
                          
                          Case "C"
                            
                            ;Set All The Same
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5 
                            PathPoints(DrawElement)\Arg3 = X/5
                            PathPoints(DrawElement)\Arg4 = Y/5 
                            PathPoints(DrawElement)\Arg5 = X/5
                            PathPoints(DrawElement)\Arg6 = Y/5 
                            
                          Case "L"
                          
                            ;End Point Of Line
                            PathPoints(DrawElement)\Arg1 = X/5 
                            PathPoints(DrawElement)\Arg2 = Y/5
                          
                        EndSelect ;ChooseElement::Type
                        
                      EndIf
                      
                      CurrentAction = 0

                    Case 0 ;CurrentAction

                      Select PathPoints(DrawElement)\Type
                          
                        Case "A" ;VArc             
                          
                          ;Straight Line Target
                          PathPoints(DrawElement)\Arg1 = X/5
                          PathPoints(DrawElement)\Arg2 = Y/5                       
                          PathPoints(DrawElement)\Arg3 = 0
                          PathPoints(DrawElement)\Arg4 = 0
                          PathPoints(DrawElement)\Arg5 = 0
                          CurrentAction = 1 
                          
                        Case "C"
                          
                          ;End Point
                          PathPoints(DrawElement)\Arg5 = X/5
                          PathPoints(DrawElement)\Arg6 = Y/5  
                          CurrentAction = 1

                        Case "L" ;Line
                          
                          ;End Point Of Line
                          PathPoints(DrawElement)\Arg1 = X/5
                          PathPoints(DrawElement)\Arg2 = Y/5
                          
                          ;Line Finished
                          DrawElement = DrawElement + 1
                          ReDim  PathPoints(DrawElement) 
                          ChooseElement::Open()
                          If ChooseElement::EndPath = #True
                            
                            Main::Drawmode = "Idle"                    
                            Main::SaveElement("Path")  
                            Done = #True
                            
                          Else
                            
                            PathPoints(DrawElement)\Type = ChooseElement::Type
                            Select ChooseElement::Type
                              Case "A"
                                ArcRadius = ChooseElement::Radius  * 5   
                                PathPoints(DrawElement)\Arg1 = X/5
                                PathPoints(DrawElement)\Arg2 = Y/5                                  
                                PathPoints(DrawElement)\Arg3 = 0 
                                PathPoints(DrawElement)\Arg4 = 0 
                                PathPoints(DrawElement)\Arg5 = 0                                
                                CurrentAction = 0           
                              Case "C"
                            
                                ;Set All The Same
                                PathPoints(DrawElement)\Arg1 = X/5
                                PathPoints(DrawElement)\Arg2 = Y/5 
                                PathPoints(DrawElement)\Arg3 = X/5
                                PathPoints(DrawElement)\Arg4 = Y/5 
                                PathPoints(DrawElement)\Arg5 = X/5
                                PathPoints(DrawElement)\Arg6 = Y/5 
                                CurrentAction = 0                 
                                
                              Case "L"
                                
                                ;End Point Of Line
                                PathPoints(DrawElement)\Arg1 = X/5 
                                PathPoints(DrawElement)\Arg2 = Y/5
                                CurrentAction = 0
                                
                            EndSelect ;ChooseElement::Type
                            CurrentAction = 0
                          EndIf
                          
                      EndSelect ;PathPoints(DrawElement)\Type
                      
                    Case 1 ;CurrentAction
                      
                      Select PathPoints(DrawElement)\Type
                          
                        Case "A" ;VArc             
                          
                          ;Target For Arc
                          PathPoints(DrawElement)\Arg3 = X/5
                          PathPoints(DrawElement)\Arg4 = Y/5                       
                          PathPoints(DrawElement)\Arg5 = ArcRadius

                          ;VArc Finished
                          DrawElement = DrawElement + 1
                          ReDim  PathPoints(DrawElement) 
                          ChooseElement::Open()
                          If ChooseElement::EndPath = #True
                            
                            Main::Drawmode = "Idle"                    
                            Main::SaveElement("Path")  
                            Done = #True
                            
                          Else
                            
                            PathPoints(DrawElement)\Type = ChooseElement::Type
                            
                            Select ChooseElement::Type
                                
                              Case "A"
                                ArcRadius = ChooseElement::Radius  * 5 
                                PathPoints(DrawElement)\Arg1 = X/5
                                PathPoints(DrawElement)\Arg2 = Y/5                                
                                PathPoints(DrawElement)\Arg3 = 0
                                PathPoints(DrawElement)\Arg4 = 0     
                                PathPoints(DrawElement)\Arg5 = 0 
                                CurrentAction = 0           
                                
                              Case "C"
                            
                                ;Set All The Same
                                PathPoints(DrawElement)\Arg1 = X/5
                                PathPoints(DrawElement)\Arg2 = Y/5 
                                PathPoints(DrawElement)\Arg3 = X/5
                                PathPoints(DrawElement)\Arg4 = Y/5 
                                PathPoints(DrawElement)\Arg5 = X/5
                                PathPoints(DrawElement)\Arg6 = Y/5 
                                CurrentAction = 0
                             
                              Case "L"
                                
                                ;End Point Of Line
                                PathPoints(DrawElement)\Arg1 = X/5 
                                PathPoints(DrawElement)\Arg2 = Y/5                                
                                CurrentAction = 0
                                
                            EndSelect ;ChooseElement::Type
                            
                          EndIf
                          
                        Case "C"
                          
                          ;First Control Point
                          PathPoints(DrawElement)\Arg1 = X/5
                          PathPoints(DrawElement)\Arg2 = Y/5  
                          CurrentAction = 2

                      EndSelect ;PathPoints(DrawElement)\Type 
                      
                    Case 2
                      
                      ;Only Curve
                      ;Second Control Point
                      PathPoints(DrawElement)\Arg3 = X/5
                      PathPoints(DrawElement)\Arg4 = Y/5  
                      CurrentAction = 3
                      
                      ;Curve Finished
                      DrawElement = DrawElement + 1
                      ReDim  PathPoints(DrawElement) 
                      ChooseElement::Open()
                      If ChooseElement::EndPath = #True
                            
                        Main::Drawmode = "Idle"                    
                        Main::SaveElement("Path")  
                        Done = #True
                            
                      Else
                            
                        PathPoints(DrawElement)\Type = ChooseElement::Type
                            
                        Select ChooseElement::Type
                                
                          Case "A"
                            
                            ArcRadius = ChooseElement::Radius  * 5 
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5                                
                            PathPoints(DrawElement)\Arg3 = 0
                            PathPoints(DrawElement)\Arg4 = 0     
                            PathPoints(DrawElement)\Arg5 = 0 
                            CurrentAction = 0           
                                
                          Case "C"
                            
                            ;Set All The Same
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5 
                            PathPoints(DrawElement)\Arg3 = X/5
                            PathPoints(DrawElement)\Arg4 = Y/5 
                            PathPoints(DrawElement)\Arg5 = X/5
                            PathPoints(DrawElement)\Arg6 = Y/5 
                            CurrentAction = 0   
                            
                          Case "L"
                                
                            ;End Point Of Line
                            PathPoints(DrawElement)\Arg1 = X/5 
                            PathPoints(DrawElement)\Arg2 = Y/5
                            CurrentAction = 0                           
                                
                        EndSelect ;ChooseElement::Type
                            
                      EndIf                     
  
                  EndSelect ;CurrentAction
                  
                Case #PB_EventType_MouseMove
                  
                  ;Only on significant move
                  If (x <> OldX) Or (y <> OldY) 
                    OldX = x
                    OldY = y
                  
                    Select CurrentAction
                        
                      Case 0
 
                        Select PathPoints(DrawElement)\Type
                            
                          Case "A"
                            
                            ;Straight Line Target
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5 
                            PathPoints(DrawElement)\Arg3 = 0
                            PathPoints(DrawElement)\Arg4 = 0
                            
                          Case "C"
                            
                            ;End Point Of Curve
                            PathPoints(DrawElement)\Arg5 = X/5
                            PathPoints(DrawElement)\Arg6 = Y/5                            
                            
                          Case "L"
                            
                            ;End Point Of Line
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5                      

                        EndSelect  ;PathPoints(DrawElement)\Type 
                        
                      Case 1
                        
                        Select PathPoints(DrawElement)\Type
                            
                          Case "A"
                            
                            ;Arc Target
                            PathPoints(DrawElement)\Arg3 = X/5
                            PathPoints(DrawElement)\Arg4 = Y/5 
                            PathPoints(DrawElement)\Arg5 = ArcRadius

                            
                          Case "C"
                            
                            ;First Control Point Of Curve
                            PathPoints(DrawElement)\Arg1 = X/5
                            PathPoints(DrawElement)\Arg2 = Y/5 
                            
                        EndSelect  ;PathPoints(DrawElement)\Type      
                       
                      
                      Case 2
                        
                            ;Second Control Point Of Curve
                            PathPoints(DrawElement)\Arg3 = X/5
                            PathPoints(DrawElement)\Arg4 = Y/5 
                        
                    EndSelect  ;CurrentAction
                    
                  EndIf
  
              EndSelect  ;EventType()
                
              Process(X,Y)

          EndSelect ;EventGadget()
          
      EndSelect     ;Event
      
   
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

  Procedure NewPath()

    ;Start the drawing operation
    ;Get the image drawn so far
    GrabDrawnImage() 
    DrawElement = 0
    ;ChooseElement::Open()
    DrawPath()
    Main::Drawmode = "Idle"
 
  EndProcedure

 Procedure Defaults()
  
  ;Set Path Defaults
  Main::NewObject\Angle1 = 0
  Main::NewObject\Angle2 = 0  
  Main::NewObject\Closed = #False 
  Main::NewObject\Colour = RGBA(0,0,0,255)  
  Main::NewObject\Dash = #False
  Main::NewObject\DashFactor = 1.1 
  Main::NewObject\Dot = #False
  Main::NewObject\DotFactor = 1.1  
  Main::NewObject\Filled = #False
  Main::NewObject\Pathtype = "Path"  
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
; CursorPosition = 352
; FirstLine = 376
; Folding = 4+
; EnableXP