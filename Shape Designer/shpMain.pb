EnableExplicit

UseSQLiteDatabase()


DeclareModule Main
  
  Enumeration 50
    #strX1
    #strY1
    #strX2
    #strY2
    #strX3
    #strY3
    #strX4
    #strY4 
    #strRadiusX
    #strRadiusY
    #spnAngle1
    #spnAngle2
    #optOpen
    #optClosed
    #strRotation
    #btnEditPath
  EndEnumeration
  
  
  Global Shapesdb.i,CurrentShape.s,SelectedShapeID.i,ShapeLoaded.i
  Global SelectedColour.i,drgCanvas.i 
  Global Drawmode.s = "Idle"
  
  Structure DrawObject
    Pathtype.s
    Colour.i
    Trans.i
    Text.s
    X1.i
    Y1.i
    X2.i
    Y2.i
    X3.i
    Y3.i
    X4.i
    Y4.i
    RadiusX.i
    RadiusY.i
    Angle1.i
    Angle2.i
    Points.i
    Rotation.i
    Closed.i
    Width.i
    Filled.i
    Rounded.i
    Stroke.i
    Dash.i
    DashFactor.d
    Dot.i
    DotFactor.d
  EndStructure 
  Global NewObject.DrawObject
  
  ;Procedure Declares
  Declare DrawArc(*Element.DrawObject)
  Declare DrawBox(*Element.DrawObject)
  Declare DrawCurve(*Element.DrawObject)
  Declare DrawLine(*Element.DrawObject)
  Declare DrawCircle(*Element.DrawObject)
  Declare DrawEllipse(*Element.DrawObject)
  Declare DrawPath(*Element.DrawObject)
  Declare FinishPath(*Element.DrawObject)
  Declare ShowElement(*Element.DrawObject)
  Declare SaveElement(Type.s)
  
  ;Create Image To Clear Drawing Surface
  Global EmptyImg.i ,DrawnImg.i
  Global PathEndX.i,PathEndY.i
  
EndDeclareModule

IncludeFile "dlgChooseElement.pbi"
IncludeFile "dlgLoadShape.pbi"
IncludeFile "dlgEditPath.pbi"
IncludeFile "dlgNewShape.pbi"
IncludeFile "DrawArc.pbi"
IncludeFile "DrawBox.pbi"
IncludeFile "DrawCircle.pbi"
IncludeFile "DrawCurve.pbi"
IncludeFile "DrawEllipse.pbi"
IncludeFile "DrawLine.pbi"
IncludeFile "DrawPath.pbi"

Module Main
  
  Global MainWin.i,cvsRulerH.i,cvsRulerV,btnRedraw.i,btndelete.i,OldGadgetList.i
  
  ;Colour Options
  Global cntColour.i,cvsColour.i,btnSelectColour.i,UserColour.i
  
  ;Element Selection
  Global cntElementsel.i,strCurrentIcon.i,txtStatus.i,strType.i,btnNext,i,btnPrevious.i
  
  ;Element Options
  Global cntElementedit.i
  
  ;Path Options
  Global cntPathOptions.i,chkFilled.i,spnWidth.i,optStroke.i,optDash.i,optDot.i,strDashFactor.i,strDotFactor.i,chkRounded.i
  

  Global NumberOfElements.i,CurrentElement.i,CurrentShape.s
  


  Global Dim Elements.DrawObject(0) 

  ;Font For Rulers
  LoadFont(0, "Times New Roman", 8)

  Enumeration
    #mnuNewShape
    #mnuLoadShape
    #mnuSaveShape
    #mnuExit
    #mnuDrawArc
    #mnuDrawBox
    #mnuDrawCircle
    #mnuDrawCurve
    #mnuDrawEllipse
    #mnuDrawLine
    #mnuDrawPath
  EndEnumeration

  Procedure OpenShapesDB()
  
    Define DataBaseFile.s ;= "C:\PB Projects\Vector Icons (New)\Database\Shapes.spb"
    
    DatabaseFile = GetCurrentDirectory() +"Database\Shapes.spb"

    ShapesDB = OpenDatabase(#PB_Any, DatabaseFile, "", ";")

  EndProcedure  
  
  Procedure LoadElements()
    
    NumberOfElements = 0   
    CurrentElement = 0  
    If DatabaseQuery(ShapesDB, "SELECT * FROM ShapeElements WHERE ShapeID = " + StrU(SelectedShapeID) + " ORDER BY Draworder ASC;")
        
      While NextDatabaseRow(ShapesDB)
        ReDim Elements(NumberOfElements)
        Elements(NumberOfElements)\Pathtype = GetDatabaseString(ShapesDB, DatabaseColumnIndex(ShapesDB, "PathType")) 
        Elements(NumberOfElements)\Colour = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Colour"))
        Elements(NumberOfElements)\Trans = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Trans"))
        Elements(NumberOfElements)\Text = GetDatabaseString(ShapesDB, DatabaseColumnIndex(ShapesDB, "Text"))          
        Elements(NumberOfElements)\X1 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "X1"))
        Elements(NumberOfElements)\Y1 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Y1"))
        Elements(NumberOfElements)\X2 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "X2"))
        Elements(NumberOfElements)\Y2 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Y2"))      
        Elements(NumberOfElements)\X3 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "X3"))
        Elements(NumberOfElements)\Y3 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Y3"))     
        Elements(NumberOfElements)\X4 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "X4"))
        Elements(NumberOfElements)\Y4 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Y4"))
        Elements(NumberOfElements)\RadiusX = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "RadiusX"))
        Elements(NumberOfElements)\RadiusY = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "RadiusY"))
        Elements(NumberOfElements)\Angle1 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Angle1"))
        Elements(NumberOfElements)\Angle2 = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Angle2"))     
        Elements(NumberOfElements)\Points = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Points"))     
        Elements(NumberOfElements)\Rotation = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Rotation"))     
        Elements(NumberOfElements)\Closed = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Closed"))          
        Elements(NumberOfElements)\Width = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Width"))
        Elements(NumberOfElements)\Filled = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Filled"))     
        Elements(NumberOfElements)\Rounded = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Rounded"))
        Elements(NumberOfElements)\Stroke = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Stroke"))          
        Elements(NumberOfElements)\Dash = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Dash"))
        Elements(NumberOfElements)\DashFactor = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "DashFactor"))     
        Elements(NumberOfElements)\Dot = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "Dot"))
        Elements(NumberOfElements)\DotFactor = GetDatabaseLong(ShapesDB, DatabaseColumnIndex(ShapesDB, "DotFactor"))
      
        NumberOfElements = NumberOfElements + 1 

      Wend
      
      FinishDatabaseQuery(ShapesDB)
      ShapeLoaded = #True
  EndIf

EndProcedure

  Procedure SetColour(Colour.i)
    
    StartVectorDrawing(CanvasVectorOutput(cvsColour))
    ;Clear Canvas
    VectorSourceColor(RGBA(255,255,255,255))
    AddPathBox(0,0,25,25) 
    FillPath()
    ;Show selected colour
    VectorSourceColor(Colour)
    AddPathBox(0,0,25,25) 
    FillPath()
    StopVectorDrawing()
    
  EndProcedure
  
  Procedure ShowEditGadgets(Type.s)
    
    ;Clear The Edit Container
    If IsGadget(cntElementedit)
      FreeGadget(cntElementedit)
    EndIf

    ;Recreate the edit container
    UseGadgetList(OldGadgetList)
    cntElementedit = ContainerGadget(#PB_Any, 535, 230, 155, 160, #PB_Container_Single)
  
    ;Add The Element Edit Gadgets
    Select Type
        
      Case "Arc"
        
        TextGadget(#PB_Any, 60, 10, 20, 20, "X", #PB_Text_Center)    
        TextGadget(#PB_Any, 100, 10, 20, 20, "Y", #PB_Text_Center)   
        TextGadget(#PB_Any, 15, 30, 35, 20, "Centre", #PB_Text_Right)
        StringGadget(#strX1, 55, 25, 35, 20, "")
        StringGadget(#strY1, 95, 25, 35, 20, "")
        TextGadget(#PB_Any, 15, 55, 35, 20, "Radius", #PB_Text_Right)
        StringGadget(#strRadiusX, 55, 50, 30, 20, "")
        TextGadget(#PB_Any, 10, 80, 40, 20, "Angle 1", #PB_Text_Right)   
        SpinGadget(#spnAngle1, 55,75, 50, 20, 0, 360, #PB_Spin_Numeric)   
        TextGadget(#PB_Any, 10, 105, 40, 20, "Angle 2", #PB_Text_Right)      
        SpinGadget(#spnAngle2, 55, 100, 50, 20, 0, 360, #PB_Spin_Numeric)  
        OptionGadget(#optOpen, 10, 130, 45, 20, "Open")
        OptionGadget(#optClosed, 55, 130, 70, 20, "Closed")
                 
      Case "Box"
        
        TextGadget(#PB_Any, 60, 5, 20, 20, "X", #PB_Text_Center)    
        TextGadget(#PB_Any, 100, 5, 20, 20, "Y", #PB_Text_Center)   
        TextGadget(#PB_Any, 10, 25, 35, 20, "Start", #PB_Text_Right)
        StringGadget(#strX1, 55, 20, 35, 20, "")
        StringGadget(#strY1, 95, 20, 35, 20, "")
        TextGadget(#PB_Any, 10,55, 35, 20, "End", #PB_Text_Right)
        StringGadget(#strX2, 55, 50, 35, 20, "")
        StringGadget(#strY2, 95, 50, 35, 20, "")      
        
       Case "Circle"
        
        TextGadget(#PB_Any, 60, 10, 20, 20, "X", #PB_Text_Center)    
        TextGadget(#PB_Any, 100, 10, 20, 20, "Y", #PB_Text_Center)   
        TextGadget(#PB_Any, 15, 30, 35, 20, "Centre", #PB_Text_Right)
        StringGadget(#strX1, 55, 25, 35, 20, "")
        StringGadget(#strY1, 95, 25, 35, 20, "")
        TextGadget(#PB_Any, 15, 55, 35, 20, "Radius", #PB_Text_Right)
        StringGadget(#strRadiusX, 55, 50, 30, 20, "")
        
      Case "Curve"
        
         TextGadget(#PB_Any, 60, 10, 20, 20, "X", #PB_Text_Center)    
         TextGadget(#PB_Any, 100, 10, 20, 20, "Y", #PB_Text_Center)   
         TextGadget(#PB_Any, 15, 35, 35, 20, "Start", #PB_Text_Right)
         StringGadget(#strX1, 55, 30, 35, 20, "")
         StringGadget(#strY1, 95, 30, 35, 20, "")
         TextGadget(#PB_Any, 15, 60, 30, 20, "End", #PB_Text_Right)
         StringGadget(#strX4, 55, 55, 35, 20, "")
         StringGadget(#strY4, 95, 55, 35, 20, "")      
         TextGadget(#PB_Any, 15, 85, 30, 20, "Pull 1", #PB_Text_Right)
         StringGadget(#strX2, 55, 80, 35, 20, "")
         StringGadget(#strY2, 95, 80, 35, 20, "")    
         TextGadget(#PB_Any, 15, 110, 30, 20, "Pull 2", #PB_Text_Right)
         StringGadget(#strX3, 55, 105, 35, 20, "")
         StringGadget(#strY3, 95, 105, 35, 20, "")
        
       Case "Ellipse"
         
         TextGadget(#PB_Any, 60, 10, 20, 20, "X", #PB_Text_Center)    
         TextGadget(#PB_Any, 100, 10, 20, 20, "Y", #PB_Text_Center)   
         TextGadget(#PB_Any, 15, 30, 35, 20, "Centre", #PB_Text_Right)
         StringGadget(#strX1, 55, 25, 35, 20, "")
         StringGadget(#strY1, 95, 25, 35, 20, "")
         TextGadget(#PB_Any, 15, 60, 45, 20, "X Radius", #PB_Text_Right)
         StringGadget(#strRadiusX, 95, 55, 35, 20, "")
         TextGadget(#PB_Any, 15, 90, 45, 20, "Y Radius", #PB_Text_Right)     
         StringGadget(#strRadiusY, 95, 85, 35, 20, "")     
         TextGadget(#PB_Any, 15, 120, 45, 20, "Rotation", #PB_Text_Right)
         StringGadget(#strRotation, 95, 115, 30, 20, "") 
          
      Case "Line"
        
        TextGadget(#PB_Any, 60, 5, 20, 20, "X", #PB_Text_Center)    
        TextGadget(#PB_Any, 100, 5, 20, 20, "Y", #PB_Text_Center)   
        TextGadget(#PB_Any, 10, 25, 35, 20, "Start", #PB_Text_Right)
        StringGadget(#strX1, 55, 20, 35, 20, "")
        StringGadget(#strY1, 95, 20, 35, 20, "")
        TextGadget(#PB_Any, 10,55, 35, 20, "End", #PB_Text_Right)
        StringGadget(#strX2, 55, 50, 35, 20, "")
        StringGadget(#strY2, 95, 50, 35, 20, "")      
  
      Case "Path"
      
        OptionGadget(#optOpen, 10, 5, 45, 20, "Open")
        OptionGadget(#optClosed, 55, 5, 70, 20, "Closed")   
        ButtonGadget(#btnEditPath, 15, 30, 120, 25, "Edit Path")  
        If Drawmode <> "Idle"
          DisableGadget(#btnEditPath,#True)
        Else
         DisableGadget(#btnEditPath,#False)       
        EndIf
       
    EndSelect
    CloseGadgetList()
    
  EndProcedure

  Procedure ShowElement(*Element.DrawObject)
    
    Define lblStatus.s
    Define Process.i = #True
    
    If Drawmode = "Idle"
      
      DisableGadget(cntElementsel,#False)     
      DisableGadget(btnNext,#False)
      DisableGadget(btnPrevious,#False)    
    
      If NumberOfElements = 0
        lblStatus = "0 Of 0"
        DisableGadget(btnNext,#True)
        DisableGadget(btnPrevious,#True) 
        SetGadgetText(txtStatus,lblStatus) 
        SetGadgetText(strType,"")     
        Process = #False
      ElseIf CurrentElement = 0 
        lblStatus = "1 Of " + Str(NumberOfElements)      
        DisableGadget(btnPrevious,#True) 
      ElseIf CurrentElement + 1 = NumberOfElements  
        lblStatus = Str(CurrentElement + 1) + " Of " + Str(NumberOfElements)       
        DisableGadget(btnNext,#True)
      Else
        DisableGadget(btnNext,#False)
        DisableGadget(btnPrevious,#False)       
        lblStatus = Str(CurrentElement + 1) + " Of " + Str(NumberOfElements)  
      EndIf
    Else
      DisableGadget(cntElementsel,#True)
    EndIf

    ;Which Icon is loaded?
    SetGadgetText(strCurrentIcon,CurrentShape)
    SetGadgetText(txtStatus,lblStatus)

    SetGadgetText(strType,*Element\Pathtype)
    
    If Process = #True
        
      ShowEditGadgets(*Element\Pathtype)

      Select *Element\Pathtype
        
        Case "Arc"

          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False)         
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
        
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf  
           If *Element\Closed = #True
            SetGadgetState(#optClosed,#True)
          Else
             SetGadgetState(#optOpen,#True)           
          EndIf         
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width))      
      
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strRadiusX,Str(*Element\RadiusX))
          SetGadgetText(#spnAngle1,Str(*Element\Angle1))
          SetGadgetText(#spnAngle2,Str(*Element\Angle2))       
        
        Case "Box"
          
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False)           
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
        
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf   
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width)) 
                    
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strX2,Str(*Element\X2))
          SetGadgetText(#strY2,Str(*Element\Y2))
        
        Case "Circle"
          
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False)         
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
         
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf   
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width))      
                    
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strRadiusX,Str(*Element\RadiusX))       
        
        Case "Curve"
          
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False)         
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
        
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf   
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width))       
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strX2,Str(*Element\X2))
          SetGadgetText(#strY2,Str(*Element\Y2))
          SetGadgetText(#strX3,Str(*Element\X3))
          SetGadgetText(#strY3,Str(*Element\Y3))
          SetGadgetText(#strX4,Str(*Element\X4))
          SetGadgetText(#strY4,Str(*Element\Y4))    
        
        Case "Ellipse"
        
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False)          
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
          
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strRadiusX,Str(*Element\RadiusX))          
          SetGadgetText(#strRadiusY,Str(*Element\RadiusY)) 
          SetGadgetText(#strRotation,Str(*Element\Rotation)) 
          
        Case "Line"
          
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#True)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False) 
          
          SelectedColour = *Element\Colour

          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf
          
          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf          
          If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf   
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width)) 
                    
          SetGadgetText(#strX1,Str(*Element\X1))
          SetGadgetText(#strY1,Str(*Element\Y1))
          SetGadgetText(#strX2,Str(*Element\X2))
          SetGadgetText(#strY2,Str(*Element\Y2))
                    
        Case "Path"
          
          DisableGadget(cntPathOptions,#False)
          DisableGadget(chkFilled,#False)          
          DisableGadget(spnWidth,#False)    
          DisableGadget(optStroke,#False)          
          DisableGadget(optDash,#False) 
          DisableGadget(optDot,#False)           
          DisableGadget(strDashFactor,#False) 
          DisableGadget(strDotFactor,#False)      
          DisableGadget(chkRounded,#False) 
          
          SelectedColour = *Element\Colour
          If SelectedColour = 0
            SetGadgetState(UserColour,#True)
            SetColour(RGBA(255,255,255,255))           
          Else
            SetGadgetState(UserColour,#False)
            SetColour(*Element\Colour)
          EndIf

          If *Element\Filled = #True
            SetGadgetState(chkFilled,#True)
          Else
            SetGadgetState(chkFilled,#False)       
          EndIf 
          If *Element\Rounded = #True
            SetGadgetState(chkRounded,#True)
          Else
            SetGadgetState(chkRounded,#False)       
          EndIf           
          If *Element\Closed = #True
            SetGadgetState(#optClosed,#True)
          Else
            SetGadgetState(#optOpen,#True)            
          EndIf
           If *Element\Stroke = #True
            SetGadgetState(optStroke,#True)
            DisableGadget(strDashFactor,#True)
            DisableGadget(strDotFactor,#True)     
          EndIf    
          If *Element\Dash = #True
            SetGadgetState(optDash,#True)
            SetGadgetState(strDashFactor,*Element\DashFactor)
            SetGadgetText(strDashFactor,StrD(*Element\DashFactor,1))
            SetGadgetText(strDotFactor,"")      
            DisableGadget(strDotFactor,#True)     
          EndIf     
          If *Element\Dot = #True
            SetGadgetState(optDot,#True)
            SetGadgetState(strDotFactor,*Element\DotFactor)
            SetGadgetText(strDotFactor,StrD(*Element\DotFactor,1))
            SetGadgetText(strDashFactor,"")     
            DisableGadget(strDashFactor,#True)     
          EndIf         
          SetGadgetState(spnWidth,*Element\Width)
          SetGadgetText(spnWidth,Str(*Element\Width)) 

      EndSelect
      
    EndIf
  
  EndProcedure
  
  Procedure SaveElement(Type.s)

    ReDim Elements(NumberOfElements)
    
    ;Element being saved becomes current element for display in edit area
    CurrentElement = NumberOfElements
  
  Elements(NumberOfElements)\Angle1 = Main::NewObject\Angle1
  Elements(NumberOfElements)\Angle2 = Main::NewObject\Angle2
  Elements(NumberOfElements)\Closed = Main::NewObject\Closed
  Elements(NumberOfElements)\Colour = Main::NewObject\Colour 
  Elements(NumberOfElements)\Dash = Main::NewObject\Dash
  Elements(NumberOfElements)\DashFactor = Main::NewObject\DashFactor
  Elements(NumberOfElements)\Dot = Main::NewObject\Dot
  Elements(NumberOfElements)\DotFactor = Main::NewObject\DotFactor
  Elements(NumberOfElements)\Filled = Main::NewObject\Filled
  Elements(NumberOfElements)\Pathtype = Main::NewObject\Pathtype
  Elements(NumberOfElements)\Points = Main::NewObject\Points  
  Elements(NumberOfElements)\RadiusX = Main::NewObject\RadiusX
  Elements(NumberOfElements)\RadiusY = Main::NewObject\RadiusY  
  Elements(NumberOfElements)\Rotation = Main::NewObject\Rotation  
  Elements(NumberOfElements)\Rounded = Main::NewObject\Rounded
  Elements(NumberOfElements)\Stroke = Main::NewObject\Stroke
  Elements(NumberOfElements)\Text = Main::NewObject\Text
  Elements(NumberOfElements)\Trans = Main::NewObject\Trans
  Elements(NumberOfElements)\Width = Main::NewObject\Width
  Elements(NumberOfElements)\X1 = Main::NewObject\X1
  Elements(NumberOfElements)\Y1 = Main::NewObject\Y1
  Elements(NumberOfElements)\X2 = Main::NewObject\X2
  Elements(NumberOfElements)\Y2 = Main::NewObject\Y2
  Elements(NumberOfElements)\X3 = Main::NewObject\X3
  Elements(NumberOfElements)\Y3 = Main::NewObject\Y3  
  Elements(NumberOfElements)\X4 = Main::NewObject\X4
  Elements(NumberOfElements)\Y4 = Main::NewObject\Y4 
  
  NumberOfElements = NumberOfElements + 1  
  
  ShowElement(Elements(CurrentElement))
  
EndProcedure 

  Procedure Save()
    
    Define Criteria.s

    If SelectedShapeID > 0
      
      Criteria = "DELETE FROM ShapeElements WHERE ShapeID = " + Str(SelectedShapeID) + " ;"
      DatabaseUpdate(Main::ShapesDB,Criteria)

      For iLoop = 0 To ArraySize(Elements())
      Criteria = "INSERT INTO ShapeElements (ShapeID,PathType,Colour,Trans,text,DrawOrder,X1,Y1,X2,Y2,X3,Y3,X4,Y4,RadiusX,RadiusY,Angle1,Angle2,Points,Rotation,Closed,Width,Filled,Rounded,Stroke,Dash,DashFactor,Dot,DotFactor)"
      Criteria = Criteria + " VALUES(" +
                 Str(SelectedShapeID) +
                 ",'" + Elements(iLoop)\Pathtype +
                 "'," + Str(Elements(iLoop)\Colour)  +
                 "," + Str(Elements(iLoop)\Trans) +
                 ",'" + Elements(iLoop)\Text + "'" +
                 "," + Str(iLoop) +
                 "," + Str(Elements(iLoop)\X1) +
                 "," + Str(Elements(iLoop)\Y1) +      
                 "," + Str(Elements(iLoop)\X2) +      
                 "," + Str(Elements(iLoop)\Y2) +      
                 "," + Str(Elements(iLoop)\X3) +
                 "," + Str(Elements(iLoop)\Y3) +      
                 "," + Str(Elements(iLoop)\X4) +      
                 "," + Str(Elements(iLoop)\Y4) +       
                 "," + Str(Elements(iLoop)\RadiusX) +      
                 "," + Str(Elements(iLoop)\RadiusY) +  
                 "," + Str(Elements(iLoop)\Angle1) +       
                 "," + Str(Elements(iLoop)\Angle2) +      
                 "," + Str(Elements(iLoop)\Points) +  
                 "," + Str(Elements(iLoop)\Rotation) +                
                 "," + Str(Elements(iLoop)\Closed) +  
                 "," + Str(Elements(iLoop)\Width) +                    
                 "," + Str(Elements(iLoop)\Filled) +                
                 "," + Str(Elements(iLoop)\Rounded) +  
                 "," + Str(Elements(iLoop)\Stroke) +       
                 "," + Str(Elements(iLoop)\Dash) +  
                 "," + Str(Elements(iLoop)\DashFactor) +       
                 "," + Str(Elements(iLoop)\Dot) +  
                 "," + Str(Elements(iLoop)\DotFactor) +         
                 ");"
      
      If DatabaseUpdate(Main::ShapesDB,Criteria) = 0

        MessageRequester("Error", "Can't execute the query: " + DatabaseError())

      EndIf  
        
      Next iLoop
    
    Else
      
      MessageRequester("Save Error","No Shape Selected",#PB_MessageRequester_Ok  )
      
    EndIf
    
  EndProcedure

  Procedure DrawRulers()

    If StartVectorDrawing(CanvasVectorOutput(cvsRulerH))
      VectorFont(FontID(0), 10)
      MovePathCursor(0, 25)
      AddPathLine(GadgetWidth(cvsRulerH),25)
      For i = 0 To VectorOutputWidth()
     
        If  Mod(i, 50) = 0
          MovePathCursor(i, 25)       
          AddPathLine(i,5)       
          MovePathCursor(i + 2,0)
          AddPathText(Str(i/5))
        ElseIf Mod(i, 5) = 0
          MovePathCursor(i, 25)
          AddPathLine(i,14)
        EndIf
     
      Next i
    EndIf
    VectorSourceColor(RGBA(100,100,100, 255))
    StrokePath(0.1)
    StopVectorDrawing()
  
    If StartVectorDrawing(CanvasVectorOutput(cvsRulerV))
      VectorFont(FontID(0), 10)
      MovePathCursor(25, 0)
      AddPathLine(25,GadgetHeight(cvsRulerV))   
      For i = 0 To VectorOutputHeight()
     
        If  Mod(i, 50) = 0
          MovePathCursor(25,i)       
          AddPathLine(5,i)       
          MovePathCursor(2,i)
          AddPathText(Str(i/5))
        ElseIf Mod(i, 5) = 0
          MovePathCursor(25,i)
          AddPathLine(20,i)
        EndIf
     
      Next i
    EndIf
    VectorSourceColor(RGBA(100,100,100, 255))
    StrokePath(0.1)
    StopVectorDrawing() 
  EndProcedure
  
  Procedure FinishPath(*Element.DrawObject)
  
    If *Element\Filled = #True
      If *Element\Rounded = #True
        FillPath(#PB_Path_Preserve )
        StrokePath(*Element\Width * 5, #PB_Path_RoundEnd|#PB_Path_RoundCorner)
      Else
        FillPath(#PB_Path_Preserve )
        StrokePath(*Element\Width * 5)      
      EndIf
    Else
      If *Element\Rounded  = #True
        If *Element\Dash = #True
          DashPath(*Element\Width * 5,*Element\Width * 5 * *Element\DashFactor,#PB_Path_RoundEnd|#PB_Path_RoundCorner)
        ElseIf *Element\Dot = #True
          DotPath(*Element\width * 5,*Element\width * 5 * *Element\DotFactor,#PB_Path_RoundEnd|#PB_Path_RoundCorner)
        ElseIf *Element\Dash = #True
          DashPath(*Element\Width* 5,*Element\Width * 5 * *Element\DashFactor,#PB_Path_RoundEnd|#PB_Path_RoundCorner)
        Else
          StrokePath(*Element\Width * 5, #PB_Path_RoundEnd|#PB_Path_RoundCorner) 
        EndIf
      Else
        If *Element\Dash = #True
          DashPath(*Element\Width * 5,*Element\Width * 5 * *Element\DashFactor)
        ElseIf *Element\Dot = #True
         DotPath(*Element\width * 5,*Element\width * 5 * *Element\DotFactor)
        Else
          StrokePath(*Element\Width * 5) 
        EndIf
      EndIf     
    EndIf 
    
  EndProcedure 
  
  Procedure SetPathGadgets(*Element.DrawObject,EventGadget.i)
            
    Select EventGadget
          
      Case  chkFilled

        If GetGadgetState(chkFilled) = #True
          *Element\Filled = #True
        Else
          *Element\Filled = #False
        EndIf
        
      Case spnWidth
        
        *Element\Width = GetGadgetState(spnWidth)
        
      Case chkRounded
        If GetGadgetState(chkRounded) = #True
          *Element\Rounded = #True
        Else
          *Element\Rounded = #False
        EndIf    
        
      Case optStroke
        DisableGadget(strDashFactor,#True)        
        DisableGadget(strDotFactor,#True)        
        If GetGadgetState(optStroke) = #True
          *Element\Stroke = #True
          *Element\Dash = #False
          *Element\Dot = #False
        EndIf       
        
      Case optDash
        DisableGadget(strDashFactor,#False)        
        DisableGadget(strDotFactor,#True)       
        If GetGadgetState(optDash) = #True
          *Element\Stroke = #False
          *Element\Dash = #True
          *Element\Dot = #False
          *Element\DashFactor = ValD(GetGadgetText(strDashFactor))
        EndIf  
        
      Case optDot
        DisableGadget(strDashFactor,#True)        
        DisableGadget(strDotFactor,#False)          
        If GetGadgetState(optDot) = #True
          *Element\Stroke = #False
          *Element\Dash = #False
          *Element\Dot = #True
          *Element\DotFactor = ValD(GetGadgetText(strDotFactor))         
        EndIf  
                 
       Case strDashFactor
         *Element\DashFactor = ValD(GetGadgetText(strDashFactor)) 
         
       Case strDotFactor
         *Element\DotFactor = ValD(GetGadgetText(strDotFactor))  
         
    EndSelect
    
  EndProcedure
  
  Procedure DrawArc(*Element.DrawObject)
     
   If *Element\Colour = 0
      Define DrawColour.i = RGBA(0,0,0,255)
      Define DrawTrans.i = 255    
    Else
      Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
      Define DrawTrans.i = Alpha(*Element\Colour)
    EndIf
    
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)
    
    If *Element\Closed = #True   
      MovePathCursor(*Element\X1 * 5, *Element\Y1 * 5)
      AddPathCircle(*Element\X1 * 5, *Element\Y1 * 5, *Element\RadiusX * 5, *Element\Angle1, *Element\Angle2, #PB_Path_Connected) 
      ClosePath()
    Else
      AddPathCircle(*Element\X1 * 5, *Element\Y1 * 5, *Element\RadiusX * 5, *Element\Angle1, *Element\Angle2) 
    EndIf
    
    FinishPath(*Element.DrawObject)
 
    EndVectorLayer()
    
EndProcedure 

  Procedure DrawBox(*Element.DrawObject)  
     
   If *Element\Colour = 0
      Define DrawColour.i = RGBA(0,0,0,255)
      Define DrawTrans.i = 255    
    Else
      Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
      Define DrawTrans.i = Alpha(*Element\Colour)
    EndIf
    Define BoxWidth.i = (*Element\X2-*Element\X1)  * 5
    Define BoxHeight.i = (*Element\Y2-*Element\Y1) * 5    
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)
    
    AddPathBox(*Element\X1 * 5, *Element\Y1 * 5, BoxWidth, BoxHeight)

    FinishPath(*Element.DrawObject)
 
    EndVectorLayer()
    
EndProcedure 

  Procedure DrawCircle(*Element.DrawObject)
   
    If *Element\Colour = 0
      Define DrawColour.i = RGBA(0,0,0,255)
      Define DrawTrans.i = 255    
    Else
      Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
      Define DrawTrans.i = Alpha(*Element\Colour)
    EndIf
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)

    AddPathCircle(*Element\X1 * 5, *Element\Y1 * 5, *Element\RadiusX * 5) 
    
    FinishPath(*Element.DrawObject)
    
    EndVectorLayer()

EndProcedure 

  Procedure DrawCurve(*Element.DrawObject)
           
    Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
    Define DrawTrans.i = Alpha(*Element\Colour)
    
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)
    
    MovePathCursor(*Element\X1 * 5, *Element\Y1 * 5)
    AddPathCurve(*Element\X2 * 5, *Element\Y2 * 5, *Element\X3 * 5, *Element\Y3 * 5, *Element\X4 * 5, *Element\Y4 * 5)

    FinishPath(*Element.DrawObject)
    
    EndVectorLayer()
     
  EndProcedure
  
  Procedure DrawEllipse(*Element.DrawObject)
             
    Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
    Define DrawTrans.i = Alpha(*Element\Colour)
    
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)
    
    ;Element\Rotation
    RotateCoordinates(*Element\X1 * 5, *Element\Y1 * 5,*Element\Rotation)    
    
    AddPathEllipse(*Element\X1 * 5, *Element\Y1 * 5, *Element\RadiusX * 5, *Element\RadiusY * 5)

    FinishPath(*Element.DrawObject)
    
    EndVectorLayer()
    
  EndProcedure  
  
  Procedure DrawLine(*Element.DrawObject)

    If *Element\Colour = 0
      Define DrawColour.i = RGBA(0,0,0,255)
      Define DrawTrans.i = 255    
    Else
      Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
      Define DrawTrans.i = Alpha(*Element\Colour)
    EndIf
    
    VectorSourceColor(DrawColour)
    BeginVectorLayer(DrawTrans)    

      MovePathCursor(*Element\X1 * 5,*Element\Y1 * 5)
      AddPathLine(*Element\X2 * 5,*Element\Y2 * 5)
      
      FinishPath(*Element.DrawObject)
      
    EndVectorLayer()
      
  EndProcedure
  
  Procedure DrawPath(*Element.DrawObject)
    
    Dim Args.i(20)
    Define NumArgs.i
    
    If *Element\Colour = 0
      Define DrawColour.i = RGBA(0,0,0,255)
      Define DrawTrans.i = 255    
    Else
      Define DrawColour.i = RGBA(Red(*Element\Colour),Green(*Element\Colour),Blue(*Element\Colour),255)
      Define DrawTrans.i = Alpha(*Element\Colour)
    EndIf
    
    VectorSourceColor(DrawColour)
    
    BeginVectorLayer(DrawTrans)    
    
    For i = 1 To CountString(*Element\Text, ",") + 1
        
    Select StringField(*Element\Text, i, ",")
      Case "M"
        NumArgs = 0
        i = i + 1
        Args(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1
        Args(NumArgs) = Val(StringField(*Element\Text, i, ","))       
        MovePathCursor(Args(0) * 5,Args(1) * 5)
      Case "L"
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))         
        AddPathLine(Args(0) * 5,Args(1) * 5)
      Case "A"
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1        
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1         
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        AddPathArc (Args(0) * 5,Args(1) * 5,Args(2) * 5,Args(3)* 5,Args(4))
        
      Case "C"
        NumArgs = 0       
        i = i + 1
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1        
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1         
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
        i = i + 1
        NumArgs = NumArgs + 1 
        Args.i(NumArgs) = Val(StringField(*Element\Text, i, ","))
     
        AddPathCurve (Args(0) * 5,Args(1) * 5,Args(2) * 5,Args(3)* 5,Args(4)* 5,Args(5)* 5)
 
      Case "Z"
        ClosePath()
    EndSelect 
    
  Next i

  PathEndX = PathCursorX()
  PathEndY = PathCursorY()
  
  FinishPath(*Element.DrawObject) 

  EndVectorLayer()
  
  EndProcedure  
    
  Procedure DrawShape()
 
    ;Clear Canvas      
    StartDrawing(CanvasOutput(drgCanvas))
    DrawImage(ImageID(EmptyImg), 0, 0)
    StopDrawing()    
 
    If NumberOfElements > 0
        
      StartVectorDrawing(CanvasVectorOutput(drgCanvas))
      
      For iLoop = 0 To NumberOfElements - 1
        
        If Elements(iLoop)\Colour = 0
          VectorSourceColor(RGBA(0,0,0,255))
        Else
          VectorSourceColor(Elements(iLoop)\Colour)
        EndIf
      
        Select Elements(iLoop)\PathType
 
          Case "Arc"
             DrawArc(@Elements(iLoop))         
            
          Case "Box"
            DrawBox(@Elements(iLoop))
          
          Case "Circle"
            DrawCircle(@Elements(iLoop))
            
          Case "Curve"
            DrawCurve(@Elements(iLoop))
            
          Case "Ellipse"
             DrawEllipse(@Elements(iLoop))         
          
          Case "Line"
            
            Drawline(@Elements(iLoop))
            
         Case "Path"
            
           DrawPath(@Elements(iLoop)) 

      EndSelect
    Next  
    
    StopVectorDrawing()  
    
  EndIf

EndProcedure

  Procedure Redraw()
  
    Elements(CurrentElement)\Colour = SelectedColour
    
    Select Elements(CurrentElement)\PathType
      
      Case "Arc"
      
      Elements(CurrentElement)\X1 = Val(GetGadgetText(#strX1))
      Elements(CurrentElement)\Y1 = Val(GetGadgetText(#strY1))
      Elements(CurrentElement)\RadiusX = Val(GetGadgetText(#strRadiusX))
      Elements(CurrentElement)\Angle1 = Val(GetGadgetText(#spnAngle1))      
      Elements(CurrentElement)\Angle2 = Val(GetGadgetText(#spnAngle2))   
      If GetGadgetState(#optClosed) = #True
        Elements(CurrentElement)\Closed = #True
      Else
        Elements(CurrentElement)\Closed = #False
      EndIf
            
    Case "Box","Line"
      
      Elements(CurrentElement)\X1 = Val(GetGadgetText(#strX1))
      Elements(CurrentElement)\Y1 = Val(GetGadgetText(#strY1))
      Elements(CurrentElement)\X2 = Val(GetGadgetText(#strX2))
      Elements(CurrentElement)\Y2 = Val(GetGadgetText(#strY2))       
      
    Case "Circle"

      Elements(CurrentElement)\X1 = Val(GetGadgetText(#strX1))
      Elements(CurrentElement)\Y1 = Val(GetGadgetText(#strY1))
      Elements(CurrentElement)\RadiusX = Val(GetGadgetText(#strRadiusX))   
      
    Case "Curve"
      
      Elements(CurrentElement)\X1 = Val(GetGadgetText(#strX1))
      Elements(CurrentElement)\Y1 = Val(GetGadgetText(#strY1))
      Elements(CurrentElement)\X2 = Val(GetGadgetText(#strX2))
      Elements(CurrentElement)\Y2 = Val(GetGadgetText(#strY2))
      Elements(CurrentElement)\X3 = Val(GetGadgetText(#strX3))
      Elements(CurrentElement)\Y3 = Val(GetGadgetText(#strY3))
      Elements(CurrentElement)\X4 = Val(GetGadgetText(#strX4))
      Elements(CurrentElement)\Y4 = Val(GetGadgetText(#strY4))      
      
    Case "Ellipse"
      
      Elements(CurrentElement)\X1 = Val(GetGadgetText(#strX1))
      Elements(CurrentElement)\Y1 = Val(GetGadgetText(#strY1))
      Elements(CurrentElement)\RadiusX = Val(GetGadgetText(#strRadiusX))
      Elements(CurrentElement)\RadiusY = Val(GetGadgetText(#strRadiusY))
      Elements(CurrentElement)\Rotation = Val(GetGadgetText(#strRotation))
      
    Case "Path"
     
      ;Closed\Open
      If GetGadgetState(#optClosed) = #True
                  
        ;Elements(CurrentElement)\LeftRight = #True
                  
        If Right(Elements(CurrentElement)\Text,1) <>"Z"

          Elements(CurrentElement)\Text = Elements(CurrentElement)\Text + ",Z"
                    
        EndIf
                  
      ElseIf Right(Elements(CurrentElement)\Text,1) = "Z"
                  
        Elements(CurrentElement)\Text = Left(Elements(CurrentElement)\Text,Len(Elements(CurrentElement)\Text)-2)
          
      Else
                 
      ;  Elements(CurrentElement)\LeftRight = #False
                  
      EndIf     

  EndSelect
 
  DrawShape()
  
EndProcedure

  Procedure EventHandler(Event.i)

    Select Event
      
      Case #PB_Event_CloseWindow 
        
        End      
        
      Case #PB_Event_Menu
        
        Select EventMenu()
            
        Case #mnuNewShape
            
          NewShape::Open()
          If NewShape::OkPressed = #True
            SelectedShapeID = NewShape::ShapeID
            CurrentShape = NewShape::Name
            LoadElements()             
            CurrentElement = 0
            ShowElement(@Elements(CurrentElement))
            DrawShape()
            Main::ShapeLoaded = #True           
          EndIf            
            
        Case #mnuLoadShape
            
          LoadShape::Open()
          If LoadShape::OkPressed = #True
            LoadElements()
            CurrentElement = 0
            ShowElement(@Elements(CurrentElement))
            DrawShape()           
 ;           DisableMenuItem(MainMenu, #mnuIconSave, #False) 
         EndIf           
          
        Case #mnuSaveShape
          
          Save()     
            
        Case #mnuExit  
            
          End
            
        Case #mnuDrawArc
          
          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Arc"
            ShowEditGadgets("Arc")
            DrawArc::Defaults()       
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf 
            
        Case #mnuDrawBox
            
          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Box"
            ShowEditGadgets("Box")
            DrawBox::Defaults()         
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf        
                    
        Case #mnuDrawCircle
          
          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Circle"
            ShowEditGadgets("Circle")
            DrawCircle::Defaults()        
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf            
          
        Case #mnuDrawCurve
          
          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Curve"
            ShowEditGadgets("Curve")
            DrawCurve::Defaults()         
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf
            
        Case #mnuDrawEllipse
            
          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Ellipse"
            ShowEditGadgets("Ellipse")
            DrawEllipse::Defaults()         
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf                     
            
        Case #mnuDrawLine

          If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Line"
            ShowEditGadgets("Line")
            DrawLine::Defaults()       
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
          Else
            MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
          EndIf         
          
        Case #mnuDrawPath
          
          ;If Main::ShapeLoaded = #True
            Main::Drawmode = "Add Path"
            ShowEditGadgets("Path")
            DrawPath::Defaults()      
            SetGadgetText(btnRedraw,"Start")
            SetGadgetText(btndelete,"Cancel")
         ; Else
          ;  MessageRequester("Shape Designer","No Shape Loaded",#PB_MessageRequester_Ok|#PB_MessageRequester_Error)
         ; EndIf          
          
 ;       Case #mnuHelpShow
          
      EndSelect  ;EventMenu()

    Case #PB_Event_Gadget
      
      Select EventGadget()
          
        Case  chkFilled,spnWidth,chkRounded,optStroke,optDash,optDot,strDashFactor,strDotFactor
          
          If Main::Drawmode = "Idle"
            SetPathGadgets(Elements(CurrentElement),EventGadget())          
          Else
            SetPathGadgets(Main::NewObject,EventGadget()) 
          EndIf 
          
        Case btnNext
            
         If CurrentElement < ArraySize(Elements())
            CurrentElement = CurrentElement + 1
          EndIf
          ShowElement(@Elements(CurrentElement))
 
        Case btnPrevious
          
          If CurrentElement > 0
            CurrentElement = CurrentElement - 1
          EndIf
          ShowElement(@Elements(CurrentElement))
            
        Case btnRedraw
          
          Select Drawmode
              
            Case "Idle"

              Redraw()
              
            Case "Add Arc"

              DrawArc::NewArc()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")  
              
            Case "Add Box"

              DrawBox::NewBox()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")              
              
            Case "Add Circle"

              DrawCircle::NewCircle()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")             
              
            Case "Add Curve"

              DrawCurve::NewCurve()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")              
              
            Case "Add Ellipse"

              DrawEllipse::NewEllipse()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")              
                            
            Case "Add Line"

              DrawLine::NewLine()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete") 
               
            Case "Add Path"

              DrawPath::NewPath()
              SetGadgetText(btnRedraw,"ReDraw")
              SetGadgetText(btndelete,"Delete")    
              
          EndSelect         
            
        Case btnSelectColour
          
          ;Call ColourRequester with current colour
          Colour = ColorRequester(RGB(Red(SelectedColour),Green(SelectedColour),Blue(SelectedColour)))
          If Colour > -1
            SelectedColour = RGBA(Red(Colour),Green(Colour),Blue(Colour),255)  
            SetColour(SelectedColour)
            SetGadgetState(UserColour,#False)  
          EndIf         
            
        Case UserColour
          
          If GetGadgetState(UserColour) = #True
            SelectedColour = 0 
            SetColour(SelectedColour)            
          EndIf 
                      
        Case #btnEditPath
 
          Elements(CurrentElement)\Text =  EditPath::Open(Elements(CurrentElement)\Text)            

        Case btnDelete
          
          If Main::Drawmode = "Idle"

            If CurrentElement > -1
              For a=CurrentElement To ArraySize(Elements())-1
                Elements(a) = Elements(a+1)
              Next 
              If ArraySize(Elements()) > 0
                ReDim Elements(ArraySize(Elements())-1)
              EndIf           
            EndIf
            NumberOfElements = NumberOfElements - 1        
            If CurrentElement > 0
              CurrentElement = CurrentElement - 1
            EndIf
            ShowElement(@Elements(CurrentElement))
          
          Else
            
            Main::Drawmode = "Idle"
            SetGadgetText(btnRedraw,"ReDraw")
            SetGadgetText(btndelete,"Delete") 
            ShowElement(@Elements(CurrentElement))
            
          EndIf
   
        EndSelect  ;EventGadget()
      
    EndSelect  ;Event  
 
  EndProcedure

OpenShapesDB()

MainWin = OpenWindow(#PB_Any, 0, 0, 695, 580, "Shape designer", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;Move window to top of screen horizontally centered
ResizeWindow(MainWin,#PB_Ignore,0,#PB_Ignore,#PB_Ignore)
CreateMenu(0, WindowID(MainWin))
MenuTitle("Shapes")
MenuItem(#mnuNewShape, "New") 
MenuItem(#mnuLoadShape, "Load") 
MenuItem(#mnuSaveShape, "Save") 
MenuItem(#mnuExit, "Exit") 
MenuTitle("Draw")
MenuItem(#mnuDrawArc, "Arc")
MenuItem(#mnuDrawBox, "Box")
MenuItem(#mnuDrawCircle, "Circle")
MenuItem(#mnuDrawCurve, "Curve")
MenuItem(#mnuDrawEllipse, "Ellipse")
MenuItem(#mnuDrawLine, "Line")
MenuItem(#mnuDrawPath, "Path")

;Ruler Gadgets
cvsRulerH = CanvasGadget(#PB_Any, 25, 0, 500,25)  ;Horizontal Ruler
cvsRulerV = CanvasGadget(#PB_Any, 0, 25, 25,500)  ;Vertical Ruler
DrawRulers()  ;Draw The Ruler Lines

;drawing Surface
drgCanvas = CanvasGadget(#PB_Any, 25, 25, 500, 500)

;Grab The Empty Image
StartDrawing(CanvasOutput(drgCanvas))
EmptyImg = GrabDrawingImage(#PB_Any, 0, 0, 500, 500)
StopDrawing()

;Element Selection Gadgets
cntElementsel = ContainerGadget(#PB_Any, 535, 5, 155, 135, #PB_Container_Single)
txtCurrentIcon = TextGadget(#PB_Any, 10, 10, 140, 20, "Current Shape")
strCurrentIcon = StringGadget(#PB_Any,10, 30, 140, 20, "")  
TextGadget(#PB_Any, 10, 60, 60, 20, "Element")
txtStatus = TextGadget(#PB_Any, 40, 80, 70, 20, " 0 Of 0 ", #PB_Text_Center)    
btnPrevious = ButtonGadget(#PB_Any, 10, 75, 25, 25, "<")
DisableGadget(btnPrevious,#True)
btnNext = ButtonGadget(#PB_Any, 115, 75, 25, 25, ">")
DisableGadget(btnNext,#True)
strType = StringGadget(#PB_Any, 10, 105, 140, 20, "")
CloseGadgetList()

;Colour Selection Gadgets
cntColour = ContainerGadget(#PB_Any, 535, 145, 155, 80, #PB_Container_Single)
  btnSelectColour = ButtonGadget(#PB_Any, 10, 10, 90, 25, "Select Colour")
  cvsColour = CanvasGadget(#PB_Any, 110, 10, 25, 25, #PB_Canvas_Border)
  UserColour = CheckBoxGadget(#PB_Any, 10, 50, 70, 20, "User Set", #PB_Text_Right)
CloseGadgetList()
  
;Element Edit Gadgets
cntElementedit = ContainerGadget(#PB_Any, 535, 230, 155, 160, #PB_Container_Single)
CloseGadgetList()

;Path Options
cntPathOptions = ContainerGadget(#PB_Any, 535, 395, 155, 130, #PB_Container_Single)
  chkFilled = CheckBoxGadget(#PB_Any, 10, 10, 50, 20, "Filled") 
  TextGadget(#PB_Any,70,13,30,20,"Width")
  spnWidth = SpinGadget(#PB_Any, 100, 10, 40, 20, 1, 50, #PB_Spin_Numeric)
  chkRounded = CheckBoxGadget(#PB_Any, 90, 40, 70, 20, "Rounded") 
  optStroke = OptionGadget(#PB_Any, 10, 40, 50, 20, "Solid")
  optDash = OptionGadget(#PB_Any, 10, 70, 55, 20, "Dashed")
  optDot = OptionGadget(#PB_Any, 10, 100, 55, 20, "Dotted")
  TextGadget(#PB_Any,70,73,30,20,"Factor")
  strDashFactor = StringGadget(#PB_Any, 105, 70, 40, 20,"1.5")
  TextGadget(#PB_Any,70,103,30,20,"Factor")
  strDotFactor = StringGadget(#PB_Any, 105, 100, 40, 20,"1.5")
CloseGadgetList()
  
btnRedraw = ButtonGadget(#PB_Any, 560, 530, 50, 25, "Redraw")
btndelete = ButtonGadget(#PB_Any, 630, 530, 50, 25, "Delete")

OldGadgetList = UseGadgetList(WindowID(MainWin))

SelectedColour = RGBA(0,0,0,255)

Repeat
  
  Event = WaitWindowEvent()
  
  Select EventWindow() 
      
    Case MainWin

      EventHandler(Event)

    Case HelpWindow

 ;     HelpViewer::EventHandler(Event)
      
  EndSelect ;EventWindow() 

ForEver

EndModule
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 1605
; FirstLine = 471
; Folding = DAA9
; EnableXP