;===========================================================
;
;   canvasToolTip() adds tooltip functionality to
;   multiple CanvasGadgets() in a single project
;
;   tested & working with PureBasic v5.5 (x64) on:
;   - Windows 8.1 and Windows 10
;   - Mac OSX 10.7.5 (without clipmouse support)
;   - Windows XP SP3 with PureBasic v5.41 (x86)
;
;   by TI-994A - free to use, improve, share...
;
;   23rd November 2016
;
;===========================================================
Global canvasImage.i
;drop-in tooltip function for multiple canvas gadgets
;

Global Dim ToolTips.s(10)

ToolTips(0) = "Select Start"
ToolTips(1) = "Select End"

Procedure canvasToolTip(gadget, Tip.i,event)
  Static init, ttFont, mouseDown
  Protected x = GetGadgetAttribute(gadget, #PB_Canvas_MouseX),
            y = GetGadgetAttribute(gadget, #PB_Canvas_MouseY),
            width = GadgetWidth(gadget),
            height = GadgetHeight(gadget),
            ;ttXvalue.s = Trim("X = " + Str(x))
            ;ttYvalue.s = Trim("Y = " + Str(y))
            ttXvalue.s = ToolTips(Tip)
            ttYvalue.s = ""
  If Not init
    init = #True
    ttFont = LoadFont(#PB_Any, "Arial", 8)
  EndIf       
 
 
 
  StartDrawing(CanvasOutput(gadget))
    Select event
      ;Case #PB_EventType_LeftButtonUp  ,#PB_EventType_MouseLeave 
      Case #PB_EventType_MouseLeave
        mouseDown = #False
        DrawImage(ImageID(canvasImage), 0, 0)
 
      ;Case #PB_EventType_LeftButtonDown,#PB_EventType_MouseEnter
      Case #PB_EventType_MouseEnter
        Debug "Init "
        canvasImage = GrabDrawingImage(#PB_Any, 0, 0, width, height)
        ;SetGadgetData(gadget, canvasImage)
        mouseDown = #True
        ;If IsImage(canvasImage)
        ;  Debug "Is Image"
        ;EndIf
        
      Case #PB_EventType_MouseMove
        
        If mouseDown = #True
        If TextWidth(ttXvalue) < TextWidth(ttYvalue)
          ttWidth = TextWidth(ttYvalue)
        Else
          ttWidth = TextWidth(ttXvalue)
        EndIf         
     
        ttWidth + 10
        ttHeight = (TextHeight(ttXvalue) * 2) + 10
        If (y + ttHeight) > height
          y - ttHeight
        EndIf
        If (x + ttWidth) > width
          x - ttWidth
        EndIf
        x + 10 : y + 5 : y2 + (y + TextHeight(ttXvalue))
    
      
      DrawingFont(FontID(ttFont))     
      DrawingMode(#PB_2DDrawing_Transparent)         
      DrawImage(ImageID(canvasImage), 0, 0)
      Box(x - 10, y - 5, ttWidth, ttHeight, RGB(255,255,255))
      DrawText(x, y, ttXValue, RGB(0, 0, 255))
      DrawText(x, y2, ttYValue, RGB(0, 0, 255))
    EndIf
    EndSelect
  StopDrawing()
 
EndProcedure

;demo code
;
InitNetwork()
UseJPEGImageDecoder()

Dim canvas(3)
wFlags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
mainWindow = OpenWindow(#PB_Any, #PB_Ignore, #PB_Ignore,
                        430, 430, "Canvas ToolTips", wFlags)
canvas(0) = CanvasGadget(#PB_Any, 10, 10, 200, 200, #PB_Canvas_Keyboard | #PB_Canvas_ClipMouse)
canvas(1) = CanvasGadget(#PB_Any, 220, 10, 200, 200, #PB_Canvas_Keyboard | #PB_Canvas_ClipMouse)
canvas(2) = CanvasGadget(#PB_Any, 10, 220, 200, 200, #PB_Canvas_Keyboard | #PB_Canvas_ClipMouse)
canvas(3) = CanvasGadget(#PB_Any, 220, 220, 200, 200, #PB_Canvas_Keyboard | #PB_Canvas_ClipMouse)

;downloading sample image from DropBox
If FileSize(GetTemporaryDirectory() + "cars.jpg") < 1
  ReceiveHTTPFile("https://dl.dropboxusercontent.com/u/171258023/cars.jpg",
                  GetTemporaryDirectory() + "cars.jpg")
EndIf

imageFile.s = GetTemporaryDirectory() + "cars.jpg"
testImage = LoadImage(#PB_Any, imageFile)
If IsImage(testImage)
 
  For i = 0 To 3
    StartDrawing(CanvasOutput(canvas(i)))
      imgSegment = GrabImage(testImage, #PB_Any, x, y, 200, 200)
      DrawImage(ImageID(imgSegment), 0, 0, 200, 200)
      DrawingMode(#PB_2DDrawing_Transparent)         
      DrawText(10, 10, "CANVAS " + Str(i + 1), RGB(255, 255, 255))
    StopDrawing()
    x + 200
  Next i
 ThisTip = 0
  Repeat
    Select WaitWindowEvent()
      Case  #PB_Event_CloseWindow
        appQuit = 1
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case canvas(0), canvas(1), canvas(2), canvas(3)
            Select EventType()
               Case #PB_EventType_MouseLeave
                canvasToolTip(EventGadget(), ThisTip,#PB_EventType_MouseLeave)               
              Case #PB_EventType_MouseEnter
                canvasToolTip(EventGadget(), ThisTip,#PB_EventType_MouseEnter)
              Case #PB_EventType_LeftButtonDown
                ThisTip = ThisTip + 1
                canvasToolTip(EventGadget(),ThisTip, #PB_EventType_LeftButtonDown)
              ;Case #PB_EventType_LeftButtonUp
                ;canvasToolTip(EventGadget(), #PB_EventType_LeftButtonUp)
              Case #PB_EventType_MouseMove
                canvasToolTip(EventGadget(),ThisTip, #PB_EventType_MouseMove)
            EndSelect
        EndSelect
    EndSelect
  Until appQuit
 
EndIf
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 50
; FirstLine = 31
; Folding = -
; EnableXP