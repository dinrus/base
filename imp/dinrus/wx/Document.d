module wx.Document;
public import wx.common;
public import wx.EvtHandler;

//! \cond VERSION
version(NOT_READY_YET)
{

    //-----------------------------------------------------------------------------
    extern(D) class Документ : ОбработчикСоб
    {
        public  this(Документ родитель);
        public проц имяФайла(ткст имяф, бул notifyViews);
        public проц имяФайла(ткст значение);
        public ткст имяФайла();
        public проц титул(ткст значение);
        public ткст титул();
        public проц имяДокумента(ткст значение);
        public ткст имяДокумента();
        public бул докСохранён();
        public проц докСохранён(бул значение);
        public бул закрой();
        public бул сохрани();
        public бул сохраниКак();
        public бул реверт();
        public бул удалиСодержимое();
        public бул рисуй(КонтекстУстройства ку);
        public бул изменён();
        public проц изменён(бул значение);		
        public проц измени(бул mod);
        public проц уведомиОЗакрытии();
        public бул удалиВсеВиды();
        public Окно окноДокумента();
    }
} // version(NOT_READY_YET)
//! \endcond
