module sys.com.msscript;

private import stdrus, sys.com.activex, sys.WinIfaces;


export class СкриптДвижок
{
	private АктивОбъ m_axo; 	
	private ткст м_движок = "VBScript";
export:
    this(ткст движок)
    {
		м_движок = движок;
    }

	~this()
	{		
	}
	
	public проц пуск()
	{
		debug(MsScript) скажинс("Запускаем скрипт-движок...");
		m_axo = new АктивОбъ("MSScriptControl.ScriptControl");
		m_axo.установи("Language", вар(м_движок)); 
	}

	public проц выполни(ткст команда)
	{		
		debug(MsScript) скажинс("выполнить: " ~ команда);
        m_axo.вызови("ExecuteStatement", вар(команда)); 
	}
	
	/+
	public  eval(ткст procName,ткст парамы, OUT VARIANT result)
	{		
		debug(MsScript) скажинс("eval: " ~ procName);
        m_axo.вызови("Eval", вар(procName, вар(парамы), result); 
	}
+/
	public проц стоп()
	{
        m_axo.вызови("Release"); 
	}

	public проц сброс()
	{
		m_axo.вызови("Reset");
	}
	
}

export class ВБСкриптДвижок: СкриптДвижок
{
export:
	this()
	{
		super("VBScript");
	}		
}	
	
export class ДжейСкриптДвижок: СкриптДвижок
{
export:
	this()
	{
		super("JScript");
	}		
}

export class СкриптКонтроль
{
    private ткст м_имя;
    private ткст м_объкласс;
    private бит м_первичный = да; /* м_первичный is да by default */
	private ткст м_движок = "VBScript";

	private СкриптДвижок сд; //АктивОбъ m_axo; 
export:
    this(ткст имя, ткст имяКласса)
    {
        this(имя, имяКласса, м_первичный, м_движок);
    }    

    this(ткст имя, ткст имяКласса, бит первичный)
    {
        this(имя, имяКласса, первичный, м_движок);
    }    

    this(ткст имя, ткст имяКласса, бит первичный, ткст движок) /* CreateObject */
    {
        м_имя = имя;        
        м_объкласс = имяКласса;
        м_первичный = первичный;
		м_движок = движок;

        if(м_первичный) 
		{
			сд = new СкриптДвижок(движок);
			сд.пуск();  /* How do I keep this from being called more than once? */
		}
        сд.выполни("Dim " ~ имя);
        сд.выполни("Set " ~ имя ~ " = CreateObject(\"" ~ имяКласса ~ "\")");
    }    

    ~this() 
    {
        if(м_первичный) сд.стоп();  /* _primary is использован to keep this from being called more than once */
    }
    
    public проц установи(ткст свойство)
    {
        сд.выполни(м_имя ~ "." ~ свойство);
    }    

    public проц установи(ткст свойство, ткст знач)
    {
        сд.выполни(м_имя ~ "." ~ свойство ~ " = " ~ знач);
    }    	
}


export class ВБСкриптКонтроль: СкриптКонтроль
{
export:
    this(ткст имя, ткст имяКласса) 
    {
        super(имя, имяКласса, да, "VBScript");
    }    

    this(ткст имя, ткст имяКласса, бит первичный) 
    {
		super(имя, имяКласса, первичный, "VBScript"); 
    }    

	~this()
	{
		//~super(); //super.~this();
	}
}



export class ДжейСкриптКонтроль: СкриптКонтроль
{
export:
    this(ткст имя, ткст имяКласса) 
    {
        super(имя, имяКласса, да, "JScript");
    }    

    this(ткст имя, ткст имяКласса, бит первичный)
    {
        super(имя, имяКласса, первичный, "JScript"); 
    }    

	~this()
	{
		//super.~this();
	}
}

private ВБСкриптДвижок двиг;
бул вбпущен = нет;

export проц вбс(ткст инстр)
	{
	if(!вбпущен)
	{
	двиг = new ВБСкриптДвижок();
	двиг.пуск();
	вбпущен = да;
	}	
	двиг.выполни(инстр);	
	}
	
export проц вбкон()
	{
	if(вбпущен)
	двиг.стоп();
	}
	
export проц вбОбъ(ткст имя, ткст объ)
	{
	ткст a = ("Dim "~имя~": Set "~имя~" = CreateObject(\""~объ~"\")");
	вбс(a);	
	}
export проц вбУст(ткст имя, ткст объ)
	{
	ткст a = ("Set "~имя~" = "~объ);
	вбс(a);	
	}
	
private ДжейСкриптДвижок джейдв;
бул джейпущен = нет;

export проц джейс(ткст инстр)
	{
	if(!джейпущен)
	{
	джейдв = new ДжейСкриптДвижок();
	джейдв.пуск();
	джейпущен = да;
	}	
	джейдв.выполни(инстр);	
	}
	
export проц джейкон()
	{
	if(джейпущен)
	джейдв.стоп();
	}
/*	
проц vbso(ткст имя, ткст объ)
	{
	ткст a = ("Dim "~имя~": Set "~имя~" = CreateObject(\""~объ~"\")");
	js(a);	
	}
проц vbset(ткст имя, ткст объ)
	{
	ткст a = ("Set "~имя~" = "~объ);
	vbs(a);	
	}
*/

