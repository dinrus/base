/*******************************************************************************
        Содержит классы, предоставляющие информацию о локалях, такую как о
        языке и календарях, а также о культурных соглашениях, используемых
        для форматирования дат, валюты и чисел. Используются эти классы при
        написании приложений для междкнародной аудитории.

******************************************************************************/

/**
 * $(MEMBERTABLE
 * $(TR
 * $(TH Interface)
 * $(TH Описание)
 * )
 * $(TR
 * $(TD $(LINK2 #ИСлужбаФормата, ИСлужбаФормата))
 * $(TD Получает объект для контроля за форматированием.)
 * )
 * )
 *
 * $(MEMBERTABLE
 * $(TR
 * $(TH Класс)
 * $(TH Описание)
 * )
 * $(TR
 * $(TD $(LINK2 #Календарь, Календарь))
 * $(TD Представляет время, разделённое на недели, месяцы и годы.)
 * )
 * $(TR
 * $(TD $(LINK2 #Культура, Культура))
 * $(TD Предоставляет информацию о культуре, такую как её имя, календарь, образцы
 * формата даты и чисел.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматДатыВремени, ФорматДатыВремени))
 * $(TD Определяет образ форматирования значений времени $(LINK2 #Время, Время)
 * зависящий от культуры.)
 * )
 * $(TR
 * $(TD $(LINK2 #DaylightSavingTime, DaylightSavingTime))
 * $(TD Представляет период of daylight-saving время.)
 * )
 * $(TR
 * $(TD $(LINK2 #Грегориан, Грегориан))
 * $(TD Представляет Грегорианский календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Еврейский, Еврейский))
 * $(TD Представляет Еврейский календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Hijri, Hijri))
 * $(TD Представляет календарь Хиджри.)
 * )
 * $(TR
 * $(TD $(LINK2 #Японский, Японский))
 * $(TD Представляет Японский календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #Корейский, Корейский))
 * $(TD Представляет Корейский календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #ФорматЧисла, ФорматЧисла))
 * $(TD Определяет форматирование чисел, соответствующее текущей культуре.)
 * )
 * $(TR
 * $(TD $(LINK2 #Регион, Регион))
 * $(TD Предоставляет информацию о регионе.)
 * )
 * $(TR
 * $(TD $(LINK2 #Taiwan, Taiwan))
 * $(TD Представляет Тайваньский календарь.)
 * )
 * $(TR
 * $(TD $(LINK2 #ThaiBuddhist, ThaiBuddhist))
 * $(TD Представляет Thai Buddhist Календарь.)
 * )
 * )
 *
 * $(MEMBERTABLE
 * $(TR
 * $(TH Структура)
 * $(TH Описание)
 * )
 * $(TR
 * $(TD $(LINK2 #Время, Время))
 * $(TD Represents время expressed as a дата и время of день.)
 * )
 * $(TR
 * $(TD $(LINK2 #ИнтервалВремени, ИнтервалВремени))
 * $(TD Represents a время интервал.)
 * )
 * )
 */

module text.locale.Core;

private import  text.locale.Data;
private import  time.Time, time.chrono.Calendar;



/**
 * Определяет типы культур, которые могут быть получены из Культура.дайКультуры.
 */
public enum ТипыКультур
{
    Нейтральный = 1,             /// Относится к культурам, которые связаны с каким-либо языком, но не специфичны для страны или региона.
    Особый = 2,            /// Относится к культурам, которые специфичны для страны или региона.
    Все = Нейтральный | Особый /// Относится ко всем культурам.
}


/**
 * $(ANCHOR _ИСлужбаФормата)
 * Получает объект для контроля за форматированием.
 *
 * Класс реализует $(LINK2 #ИСлужбаФормата_дайФормат, дайФормат) для получения объекта, который предоставляет информацию о формате для реализуемого типа.
 * Примечания: ИСлужбаФормата реализуется в $(LINK2 #Культура, Культура), $(LINK2 #ФорматЧисла, ФорматЧисла) и $(LINK2 #ФорматДатыВремени, ФорматДатыВремени),
 * предоставляя локале-специфичное форматирование чисел и значений времени.
 */
public interface ИСлужбаФормата
{

    /**
     * $(ANCHOR ИСлужбаФормата_дайФормат)
     * Retrieves an объект that supports formatting for the specified _тип.
     * Возвращает: The текущ экземпляр if тип is the same _тип as the текущ экземпляр; иначе, пусто.
     * Параметры: тип = An объект that specifies the _тип of formatting в_ retrieve.
     */
    Объект дайФормат(ИнфОТипе тип);

}

/**
 * $(ANCHOR _Culture)
 * Provопрes information about a культура, such as its имя, Календарь и дата и число форматируй образцы.
 * Примечания: text.locale adopts the RFC 1766 стандарт for культура names in the форматируй &lt;language&gt;"-"&lt;region&gt;.
 * &lt;language&gt; is a lower-case two-letter код defined by ISO 639-1. &lt;region&gt; is an upper-case
 * two-letter код defined by ISO 3166. Например, "en-GB" is UK English.
 * $(BR)$(BR)There are three типы of культура: invariant, neutral и specific. The invariant культура is not tied в_
 * any specific region, although it is associated with the English language. A neutral культура is associated with
 * a language, but not with a region. A specific культура is associated with a language и a region. "es" is a neutral
 * культура. "es-MX" is a specific культура.
 * $(BR)$(BR)Instances of $(LINK2 #ФорматДатыВремени, ФорматДатыВремени) и $(LINK2 #ФорматЧисла, ФорматЧисла) cannot be создан for neutral cultures.
 * Примеры:
 * ---
 * import io.Stdout, text.locale.Core;
 *
 * проц main() {
 *   Культура культура = new Культура("it-IT");
 *
 *   Стдвыв.форматнс("англИмя: {}", культура.англИмя);
 *   Стдвыв.форматнс("исконноеИмя: {}", культура.исконноеИмя);
 *   Стдвыв.форматнс("имя: {}", культура.имя);
 *   Стдвыв.форматнс("родитель: {}", культура.родитель.имя);
 *   Стдвыв.форматнс("нейтрален_ли: {}", культура.нейтрален_ли);
 * }
 *
 * // Produces the following вывод:
 * // англИмя: Italian (Italy)
 * // исконноеИмя: italiano (Italia)
 * // имя: it-IT
 * // родитель: it
 * // нейтрален_ли: нет
 * ---
 */
extern(D) class Культура : ИСлужбаФормата
{

    /**
     * Инициализирует новый экземпляр Культуры по предоставленному имени.
     * Параметры: названиеКультуры = Название Культуры.
     */
    public this(ткст названиеКультуры);

    /**
     * Инициализует новый экземпляр Культуры по предоставленному идентификатору культуры.
     * Параметры: идКультуры = Идентификатор (ЛКИД) этой Культуры.
     * Примечания: Идентификатору Культуры соответствует определённый Windows LCID.
     */
    public this(цел идКультуры );

    /**
     * Получает объект, определяющий, как форматировать указанный тип.
     * Параметры: тип = ИнфОТипе результирующего объекта форматирования.
     * Возвращает: Если тип является typeid($(LINK2 #ФорматЧисла, ФорматЧисла)), значение $(LINK2 #Культура_форматЧисла, форматЧисла) property. If тип is typeid($(LINK2 #ФорматДатыВремени, ФорматДатыВремени)),
     * значение свойства $(LINK2 #Культура_форматДатыВремени, форматДатыВремени). Иначе - пусто.
     * Примечания: Реализует $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат).
     */
    public Объект дайФормат(ИнфОТипе тип);

    version (Clone)
    {
        /**
         * Копирует текущий экземпляр Культуры.
         * Возвращает: Копию текущего экземпляра класса Культура.
         * Примечания: Значения свойств $(LINK2 #Культура_форматЧисла, форматЧисла), $(LINK2 #Культура_форматДатыВремени, форматДатыВремени) и $(LINK2 #Культура_Календарь, Календарь) также копируются.
         */
        public Объект клонируй();
    }

    /**
     * Возвращает экземпляр только для чтения культуры, используя заданный идентификатор культуры.
     * Параметры: идКультуры = Идентификатор данной культуры.
     * Возвращает: Экземпляр культуры, только для чтения.
     * Примечания: Возвращаемые этим методом экземпляры кэшируются.
     */
    public static Культура дайКультуру(цел идКультуры);

    /**
     * Возвращает экземпляр только для чтения культуры, используя заданное имя культуры.
     * Параметры: названиеКультуры = Имя культуры.
     * Возвращает: Экземпляр культуры, только для чтения.
     * Примечания: Возвращаемые этим методом экземпляры кэшируются.
     */
    public static Культура дайКультуру(ткст названиеКультуры);

    /**
      * Возвращает экземпляр только для чтения, используя заданное имя, как определяет стандарт RFC 3066, поддерживаемый IETF.
      * Параметры: имя = Имя языка.
      * Возвращает: Экземпляр культуры, только для чтения.
      */
    public static Культура дайКультуруПоТегуЯзыкаИЕТФ(ткст имя);

    /**
     * Возвращает список of cultures filtered by the specified $(LINK2 константы.html#ТипыКультур, ТипыКультур).
     * Параметры: типы = A combination of ТипыКультур.
     * Возвращает: An Массив of Культура экземпляры containing cultures specified by типы.
     */
    public static Культура[] дайКультуры(ТипыКультур типы);

    /**
     * Возвращает the имя of the Культура.
     * Возвращает: A ткст containing the имя of the Культура in the форматируй &lt;language&gt;"-"&lt;region&gt;.
     */
    public override ткст вТкст();

    public override цел opEquals(Объект об);

    /**
     * $(ANCHOR Culture_current)
     * $(I Property.) Retrieves the культура of the текущ пользователь.
     * Возвращает: The Культура экземпляр representing the пользователь's текущ культура.
     */
    public static Культура текущ();
	
    /**
     * $(I Property.) Assigns the культура of the _current пользователь.
     * Параметры: значение = The Культура экземпляр representing the пользователь's _current культура.
     * Примеры:
     * The following examples shows как в_ change the _current культура.
     * ---
     * import io.stream.Format, text.locale.Common;
     *
     * проц main() {
     *   // Displays the имя of the текущ культура.
     *   Println("The текущ культура is %s.", Культура.текущ.англИмя);
     *
     *   // Changes the текущ культура в_ el-GR.
     *   Культура.текущ = new Культура("el-GR");
     *   Println("The текущ культура is сейчас %s.", Культура.текущ.англИмя);
     * }
     *
     * // Produces the following вывод:
     * // The текущ культура is English (United Kingdom).
     * // The текущ культура is сейчас Greek (Greece).
     * ---
     */
    public static проц текущ(Культура значение);

    /**
     * $(I Property.) Retrieves the invariant Культура.
     * Возвращает: The Культура экземпляр that is invariant.
     * Примечания: The invariant культура is культура-independent. It is not tied в_ any specific region, but is associated
     * with the English language.
     */
    public static Культура инвариантнаяКультура();

    /**
     * $(I Property.) Retrieves the определитель of the Культура.
     * Возвращает: The культура определитель of the текущ экземпляр.
     * Примечания: The культура определитель corresponds в_ the Windows локаль определитель (LCID). It can therefore be использован when
     * interfacing with the Windows NLS functions.
     */
    public цел ид();

    /**
     * $(ANCHOR Culture_name)
     * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;language&gt;"-"&lt;region&gt;.
     * Возвращает: The имя of the текущ экземпляр. Например, the имя of the UK English культура is "en-GB".
     */
    public ткст имя();

    /**
     * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in English.
     * Возвращает: The имя of the текущ экземпляр in English. Например, the англИмя of the UK English культура
     * is "English (United Kingdom)".
     */
    public ткст англИмя();

    /**
     * $(I Property.) Retrieves the имя of the Культура in the форматируй &lt;languagename&gt; (&lt;regionname&gt;) in its исконный language.
     * Возвращает: The имя of the текущ экземпляр in its исконный language. Например, if Культура.имя is "de-DE", исконноеИмя is
     * "Deutsch (Deutschland)".
     */
    public ткст исконноеИмя();

    /**
     * $(I Property.) Retrieves the two-letter language код of the культура.
     * Возвращает: The two-letter language код of the Культура экземпляр. Например, the имяЯзыкаИз2Букв for English is "en".
     */
    public ткст имяЯзыкаИз2Букв();

    /**
     * $(I Property.) Retrieves the three-letter language код of the культура.
     * Возвращает: The three-letter language код of the Культура экземпляр. Например, the имяЯзыкаИз3Букв for English is "eng".
     */
    public ткст имяЯзыкаИз3Букв();

    /**
     * $(I Property.) Retrieves the RFC 3066 опрentification for a language.
     * Возвращает: A ткст representing the RFC 3066 language опрentification.
     */
    public final ткст тэгЯзыкаИЕТФ();

    /**
     * $(I Property.) Retrieves the Культура representing the родитель of the текущ экземпляр.
     * Возвращает: The Культура representing the родитель of the текущ экземпляр.
     */
    public Культура родитель();

    /**
     * $(I Property.) Retrieves a значение indicating whether the текущ экземпляр is a neutral культура.
     * Возвращает: да is the текущ Культура represents a neutral культура; иначе, нет.
     * Примеры:
     * The following example displays which cultures using Chinese are neutral.
     * ---
     * import io.stream.Format, text.locale.Common;
     *
     * проц main() {
     *   foreach (c; Культура.дайКультуры(ТипыКультур.все)) {
     *     if (c.имяЯзыкаИз2Букв == "zh") {
     *       Print(c.англИмя);
     *       if (c.нейтрален_ли)
     *         Println("neutral");
     *       else
     *         Println("specific");
     *     }
     *   }
     * }
     *
     * // Produces the following вывод:
     * // Chinese (Simplified) - neutral
     * // Chinese (Taiwan) - specific
     * // Chinese (People's Republic of China) - specific
     * // Chinese (Hong Kong S.A.R.) - specific
     * // Chinese (Singapore) - specific
     * // Chinese (Macao S.A.R.) - specific
     * // Chinese (Traditional) - neutral
     * ---
     */
    public бул нейтрален_ли();

    /**
     * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
     * Возвращает: да if the экземпляр is читай-only; иначе, нет.
     * Примечания: If the культура is читай-only, the $(LINK2 #Культура_форматДатыВремени, форматДатыВремени) и $(LINK2 #Культура_форматЧисла, форматЧисла) свойства return
     * экземпляр только для чтенияы.
     */
    public final бул толькоЧтен_ли();

    /**
     * $(ANCHOR Культура_Календарь)
     * $(I Property.) Retrieves the Календарь использован by the культура.
     * Возвращает: A Календарь экземпляр respresenting the Календарь использован by the культура.
     */
    public Календарь календарь();

    /**
     * $(I Property.) Retrieves the список of Календарьs that can be использован by the культура.
     * Возвращает: An Массив of тип Календарь representing the Календарьs that can be использован by the культура.
     */
    public Календарь[] опциональныеКалендари();

    /**
     * $(ANCHOR Культура_форматЧисла)
     * $(I Property.) Retrieves a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и валюта.
     * Возвращает: A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и валюта.
    */
    public ФорматЧисла форматЧисла();
	
    /**
     * $(I Property.) Assigns a ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и валюта.
     * Параметры: значения = A ФорматЧисла defining the culturally appropriate форматируй for displaying numbers и валюта.
     */
    public проц форматЧисла(ФорматЧисла значение);

    /**
     * $(ANCHOR Культура_форматДатыВремени)
     * $(I Property.) Retrieves a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
     * Возвращает: A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
     */
    public ФорматДатыВремени форматДатыВремени();
	
    /**
     * $(I Property.) Assigns a ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
     * Параметры: значения = A ФорматДатыВремени defining the culturally appropriate форматируй for displaying dates и times.
     */
    public проц форматДатыВремени(ФорматДатыВремени значение);

}

/**
 * $(ANCHOR _Region)
 * Provопрes information about a region.
 * Примечания: Регион does not represent пользователь preferences. It does not depend on the пользователь's language or культура.
 * Примеры:
 * The following example displays some of the свойства of the Регион class:
 * ---
 * import io.stream.Format, text.locale.Common;
 *
 * проц main() {
 *   Регион region = new Регион("en-GB");
 *   Println("имя:              %s", region.имя);
 *   Println("англИмя:       %s", region.англИмя);
 *   Println("метрическ_ли:          %s", region.метрическ_ли);
 *   Println("символВалюты:    %s", region.символВалюты);
 *   Println("символВалютыИЗО: %s", region.символВалютыИЗО);
 * }
 *
 * // Produces the following вывод.
 * // имя:              en-GB
 * // англИмя:       United Kingdom
 * // метрическ_ли:          да
 * // символВалюты:    £
 * // символВалютыИЗО: GBP
 * ---
 */
extern(D) class Регион
{
    /**
     * Initializes a new Регион экземпляр based on the region associated with the specified культура определитель.
     * Параметры: идКультуры = A культура indentifier.
     * Примечания: The имя of the Регион экземпляр is установи в_ the ISO 3166 two-letter код for that region.
     */
    public this(цел идКультуры);

    /**
     * $(ANCHOR Region_ctor_name)
     * Initializes a new Регион экземпляр based on the region specified by имя.
     * Параметры: имя = A two-letter ISO 3166 код for the region. Or, a культура $(LINK2 #Culture_name, _name) consisting of the language и region.
     */
    public this(ткст имя);

    /**
     * $(I Property.) Retrieves the Регион использован by the текущ $(LINK2 #Культура, Культура).
     * Возвращает: The Регион экземпляр associated with the текущ Культура.
     */
    public static Регион текущ();

    /**
     * $(I Property.) Retrieves a unique определитель for the geographical location of the region.
     * Возвращает: An $(B цел) uniquely опрentifying the geographical location.
     */
    public цел геоИД();
	
    /**
     * $(ANCHOR Region_name)
     * $(I Property.) Retrieves the ISO 3166 код, or the имя, of the текущ Регион.
     * Возвращает: The значение specified by the имя parameter of the $(LINK2 #Region_ctor_name, Регион(ткст)) constructor.
     */
    public ткст имя();
	
    /**
     * $(I Property.) Retrieves the full имя of the region in English.
     * Возвращает: The full имя of the region in English.
     */
    public ткст англИмя();

    /**
     * $(I Property.) Retrieves the full имя of the region in its исконный language.
     * Возвращает: The full имя of the region in the language associated with the region код.
     */
    public ткст исконноеИмя();

    /**
     * $(I Property.) Retrieves the two-letter ISO 3166 код of the region.
     * Возвращает: The two-letter ISO 3166 код of the region.
     */
    public ткст имяРегионаИз2Букв();

    /**
     * $(I Property.) Retrieves the three-letter ISO 3166 код of the region.
     * Возвращает: The three-letter ISO 3166 код of the region.
     */
    public ткст имяРегионаИз3Букв();

    /**
     * $(I Property.) Retrieves the валюта symbol of the region.
     * Возвращает: The валюта symbol of the region.
     */
    public ткст символВалюты();

    /**
     * $(I Property.) Retrieves the three-character валюта symbol of the region.
     * Возвращает: The three-character валюта symbol of the region.
     */
    public ткст символВалютыИЗО();

    /**
     * $(I Property.) Retrieves the имя in English of the валюта использован in the region.
     * Возвращает: The имя in English of the валюта использован in the region.
     */
    public ткст англИмяВалюты();

    /**
     * $(I Property.) Retrieves the имя in the исконный language of the region of the валюта использован in the region.
     * Возвращает: The имя in the исконный language of the region of the валюта использован in the region.
     */
    public ткст исконноеИмяВалюты();

    /**
     * $(I Property.) Retrieves a значение indicating whether the region uses the metric system for measurements.
     * Возвращает: да is the region uses the metric system; иначе, нет.
     */
    public бул метрическ_ли();

    /**
     * Возвращает ткст containing the ISO 3166 код, or the $(LINK2 #Region_name, имя), of the текущ Регион.
     * Возвращает: A ткст containing the ISO 3166 код, or the имя, of the текущ Регион.
     */
    public override ткст вТкст();

}

/**
 * $(ANCHOR _NumberFormat)
 * Determines как numbers are formatted, according в_ the текущ культура.
 * Примечания: Numbers are formatted using форматируй образцы retrieved из_ a ФорматЧисла экземпляр.
 * This class реализует $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат).
 * Примеры:
 * The following example shows как в_ retrieve an экземпляр of ФорматЧисла for a Культура
 * и use it в_ display число formatting information.
 * ---
 * import io.stream.Format, text.locale.Common;
 *
 * проц main(ткст[] арги) {
 *   foreach (c; Культура.дайКультуры(ТипыКультур.Особый)) {
 *     if (c.имяЯзыкаИз2Букв == "en") {
 *       ФорматЧисла фмт = c.форматЧисла;
 *       Println("The валюта symbol for %s is '%s'",
 *         c.англИмя,
 *         фмт.символВалюты);
 *     }
 *   }
 * }
 *
 * // Produces the following вывод:
 * // The валюта symbol for English (United States) is '$'
 * // The валюта symbol for English (United Kingdom) is '£'
 * // The валюта symbol for English (Australia) is '$'
 * // The валюта symbol for English (Canada) is '$'
 * // The валюта symbol for English (Нов Zealand) is '$'
 * // The валюта symbol for English (Ireland) is '€'
 * // The валюта symbol for English (South Africa) is 'R'
 * // The валюта symbol for English (Jamaica) is 'J$'
 * // The валюта symbol for English (Caribbean) is '$'
 * // The валюта symbol for English (Belize) is 'BZ$'
 * // The валюта symbol for English (Trinопрad и Tobago) is 'TT$'
 * // The валюта symbol for English (Zimbabwe) is 'Z$'
 * // The валюта symbol for English (Republic of the PhilИПpines) is 'Php'
 *---
 */
extern(D) class ФорматЧисла : ИСлужбаФормата
{

    /**
     * Иициализует новый, культуро-независимый экземпляр.
     *
     * Примечания: Модифицируйте свойства нового экземпляра, чтобы определить кастомное форматирование.
     */
    public this();
	
    /**
     * Retrieves an объект defining как в_ форматируй the specified тип.
     * Параметры: тип = The ИнфОТипе of the результатing formatting объект.
     * Возвращает: If тип is typeid($(LINK2 #ФорматЧисла, ФорматЧисла)), the текущ ФорматЧисла экземпляр. Otherwise, пусто.
     * Примечания: Implements $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат).
     */
    public Объект дайФормат(ИнфОТипе тип);

    version (Clone)
    {
        /**
         * Creates a копируй of the экземпляр.
         */
        public Объект клонируй();
    }

    /**
     * Retrieves the ФорматЧисла for the specified $(LINK2 #ИСлужбаФормата, ИСлужбаФормата).
     * Параметры: службаФормата = The ИСлужбаФормата использован в_ retrieve ФорматЧисла.
     * Возвращает: The ФорматЧисла for the specified ИСлужбаФормата.
     * Примечания: The метод calls $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат) with typeof(ФорматЧисла). If службаФормата is пусто,
     * then the значение of the текущ property is returned.
     */
    public static ФорматЧисла дайЭкземпляр(ИСлужбаФормата службаФормата);

    /**
     * $(I Property.) Retrieves a читай-only ФорматЧисла экземпляр из_ the текущ культура.
     * Возвращает: A читай-only ФорматЧисла экземпляр из_ the текущ культура.
     */
    public static ФорматЧисла текущ();

    /**
     * $(ANCHOR NumberFormat_invariantFormat)
     * $(I Property.) Retrieves the читай-only, culturally independent ФорматЧисла экземпляр.
     * Возвращает: The читай-only, culturally independent ФорматЧисла экземпляр.
     */
    public static ФорматЧисла инвариантныйФормат();

    /**
     * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
     * Возвращает: да if the экземпляр is читай-only; иначе, нет.
     */
    public final бул толькоЧтен_ли();

    /**
     * $(I Property.) Retrieves the число of десяток places использован for numbers.
     * Возвращает: The число of десяток places использован for numbers. For $(LINK2 #NumberFormat_invariantFormat, инвариантныйФормат), the default is 2.
     */
    public final цел члоДесятичнЦифр();
	
    /**
     * Assigns the число of десяток цифры использован for numbers.
     * Параметры: значение = The число of десяток places использован for numbers.
     * Throws: Исключение if the property is being установи и the экземпляр is читай-only.
     * Примеры:
     * The following example shows the effect of changing члоДесятичнЦифр.
     * ---
     * import io.stream.Format, text.locale.Common;
     *
     * проц main() {
     *   // Get the ФорматЧисла из_ the en-GB культура.
     *   ФорматЧисла фмт = (new Культура("en-GB")).форматЧисла;
     *
     *   // Display a значение with the default число of десяток цифры.
     *   цел n = 5678;
     *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
     *
     *   // Display the значение with six десяток цифры.
     *   фмт.члоДесятичнЦифр = 6;
     *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
     * }
     *
     * // Produces the following вывод:
     * // 5,678.00
     * // 5,678.000000
     * ---
     */
    public final проц члоДесятичнЦифр(цел значение);

    /**
     * $(I Property.) Retrieves the форматируй образец for негатив numbers.
     * Возвращает: The форматируй образец for негатив numbers. For инвариантныйФормат, the default is 1 (representing "-n").
     * Примечания: The following таблица shows действителен значения for this property.
     *
     * <таблица class="definitionTable">
     * <tr><th>Значение</th><th>образец</th></tr>
     * <tr><td>0</td><td>(n)</td></tr>
     * <tr><td>1</td><td>-n</td></tr>
     * <tr><td>2</td><td>- n</td></tr>
     * <tr><td>3</td><td>n-</td></tr>
     * <tr><td>4</td><td>n -</td></tr>
     * </таблица>
     */
    public final цел члоОтрицатОбразцов();
	
    /**
     * $(I Property.) Assigns the форматируй образец for негатив numbers.
     * Параметры: значение = The форматируй образец for негатив numbers.
     * Примеры:
     * The following example shows the effect of the different образцы.
     * ---
     * import io.stream.Format, text.locale.Common;
     *
     * проц main() {
     *   ФорматЧисла фмт = new ФорматЧисла;
     *   цел n = -5678;
     *
     *   // Display the default образец.
     *   Println(Форматировщик.форматируй(фмт, "{0:N}", n));
     *
     *   // Display все образцы.
     *   for (цел i = 0; i <= 4; i++) {
     *     фмт.члоОтрицатОбразцов = i;
     *     Println(Форматировщик.форматируй(фмт, "{0:N}", n));
     *   }
     * }
     *
     * // Produces the following вывод:
     * // (5,678.00)
     * // (5,678.00)
     * // -5,678.00
     * // - 5,678.00
     * // 5,678.00-
     * // 5,678.00 -
     * ---
     */
    public final проц члоОтрицатОбразцов(цел значение);

    /**
     * $(I Property.) Retrieves the число of десяток places в_ use in валюта значения.
     * Возвращает: The число of десяток цифры в_ use in валюта значения.
     */
    public final цел валютнДесятичнЦифры();
	
    /**
     * $(I Property.) Assigns the число of десяток places в_ use in валюта значения.
     * Параметры: значение = The число of десяток цифры в_ use in валюта значения.
     */
    public final проц валютнДесятичнЦифры(цел значение);

    /**
     * $(I Property.) Retrieves the formal образец в_ use for негатив валюта значения.
     * Возвращает: The форматируй образец в_ use for негатив валюта значения.
     */
    public final цел валютнОтрицатОбразец();
	
    /**
     * $(I Property.) Assigns the formal образец в_ use for негатив валюта значения.
     * Параметры: значение = The форматируй образец в_ use for негатив валюта значения.
     */
    public final проц валютнОтрицатОбразец(цел значение);

    /**
     * $(I Property.) Retrieves the formal образец в_ use for positive валюта значения.
     * Возвращает: The форматируй образец в_ use for positive валюта значения.
     */
    public final цел валютнПоложитОбразец();
	
    /**
     * $(I Property.) Assigns the formal образец в_ use for positive валюта значения.
     * Возвращает: The форматируй образец в_ use for positive валюта значения.
     */
    public final проц валютнПоложитОбразец(цел значение);

    /**
     * $(I Property.) Retrieves the число of цифры цел each группа в_ the лево of the десяток place in numbers.
     * Возвращает: The число of цифры цел each группа в_ the лево of the десяток place in numbers.
     */
    public final цел[] размерыЧисловыхГрупп();
	
    /**
     * $(I Property.) Assigns the число of цифры цел each группа в_ the лево of the десяток place in numbers.
     * Параметры: значение = The число of цифры цел each группа в_ the лево of the десяток place in numbers.
     */
    public final проц размерыЧисловыхГрупп(цел[] значение);

    /**
     * $(I Property.) Retrieves the число of цифры цел each группа в_ the лево of the десяток place in валюта значения.
     * Возвращает: The число of цифры цел each группа в_ the лево of the десяток place in валюта значения.
     */
    public final цел[] размерыВалютныхГрупп();
	
    /**
     * $(I Property.) Assigns the число of цифры цел each группа в_ the лево of the десяток place in валюта значения.
     * Параметры: значение = The число of цифры цел each группа в_ the лево of the десяток place in валюта значения.
     */
    public final проц размерыВалютныхГрупп(цел[] значение);

    /**
     * $(I Property.) Retrieves the ткст separating groups of цифры в_ the лево of the десяток place in numbers.
     * Возвращает: The ткст separating groups of цифры в_ the лево of the десяток place in numbers. Например, ",".
     */
    public final ткст разделительЧисловыхГрупп();
	
    /**
     * $(I Property.) Assigns the ткст separating groups of цифры в_ the лево of the десяток place in numbers.
     * Параметры: значение = The ткст separating groups of цифры в_ the лево of the десяток place in numbers.
     */
    public final проц разделительЧисловыхГрупп(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст использован as the десяток разделитель in numbers.
     * Возвращает: The ткст использован as the десяток разделитель in numbers. Например, ".".
     */
    public final ткст разделительЧисловыхДесятков();
	
    /**
     * $(I Property.) Assigns the ткст использован as the десяток разделитель in numbers.
     * Параметры: значение = The ткст использован as the десяток разделитель in numbers.
     */
    public final проц разделительЧисловыхДесятков(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст separating groups of цифры в_ the лево of the десяток place in валюта значения.
     * Возвращает: The ткст separating groups of цифры в_ the лево of the десяток place in валюта значения. Например, ",".
     */
    public final ткст разделительГруппыВалют();
	
    /**
     * $(I Property.) Assigns the ткст separating groups of цифры в_ the лево of the десяток place in валюта значения.
     * Параметры: значение = The ткст separating groups of цифры в_ the лево of the десяток place in валюта значения.
     */
    public final проц разделительГруппыВалют(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст использован as the десяток разделитель in валюта значения.
     * Возвращает: The ткст использован as the десяток разделитель in валюта значения. Например, ".".
     */
    public final ткст десятичнРазделительВалюты();
	
    /**
     * $(I Property.) Assigns the ткст использован as the десяток разделитель in валюта значения.
     * Параметры: значение = The ткст использован as the десяток разделитель in валюта значения.
     */
    public final проц десятичнРазделительВалюты(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст использован as the валюта symbol.
     * Возвращает: The ткст использован as the валюта symbol. Например, "£".
     */
    public final ткст символВалюты();
	
    /**
     * $(I Property.) Assigns the ткст использован as the валюта symbol.
     * Параметры: значение = The ткст использован as the валюта symbol.
     */
    public final проц символВалюты(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст denoting that a число is негатив.
     * Возвращает: The ткст denoting that a число is негатив. Например, "-".
     */
    public final ткст отрицатЗнак();
	
    /**
     * $(I Property.) Assigns the ткст denoting that a число is негатив.
     * Параметры: значение = The ткст denoting that a число is негатив.
     */
    public final проц отрицатЗнак(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст denoting that a число is positive.
     * Возвращает: The ткст denoting that a число is positive. Например, "+".
     */
    public final ткст положитЗнак();
	
    /**
     * $(I Property.) Assigns the ткст denoting that a число is positive.
     * Параметры: значение = The ткст denoting that a число is positive.
     */
    public final проц положитЗнак(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст representing the НЧ (not a число) значение.
     * Возвращает: The ткст representing the НЧ значение. Например, "НЧ".
     */
    public final ткст символНЧ();
	
    /**
     * $(I Property.) Assigns the ткст representing the НЧ (not a число) значение.
     * Параметры: значение = The ткст representing the НЧ значение.
     */
    public final проц символНЧ(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст representing негатив infinity.
     * Возвращает: The ткст representing негатив infinity. Например, "-Infinity".
     */
    public final ткст отрицатСимволБесконечности();
	
    /**
     * $(I Property.) Assigns the ткст representing негатив infinity.
     * Параметры: значение = The ткст representing негатив infinity.
     */
    public final проц отрицатСимволБесконечности(ткст значение);

    /**
     * $(I Property.) Retrieves the ткст representing positive infinity.
     * Возвращает: The ткст representing positive infinity. Например, "Infinity".
     */
    public final ткст положитСимволБесконечности();
	
    /**
     * $(I Property.) Assigns the ткст representing positive infinity.
     * Параметры: значение = The ткст representing positive infinity.
     */
    public final проц положитСимволБесконечности(ткст значение);

    /**
     * $(I Property.) Retrieves a ткст Массив of исконный equivalents of the цифры 0 в_ 9.
     * Возвращает: A ткст Массив of исконный equivalents of the цифры 0 в_ 9.
     */
    public final ткст[] исконныеЦифры();
	
    /**
     * $(I Property.) Assigns a ткст Массив of исконный equivalents of the цифры 0 в_ 9.
     * Параметры: значение = A ткст Массив of исконный equivalents of the цифры 0 в_ 9.
     */
    public final проц исконныеЦифры(ткст[] значение);

}

/**
 * $(ANCHOR _DateTimeFormat)
 * Determines как $(LINK2 #Время, Время) значения are formatted, depending on the культура.
 * Примечания: To создай a ФорматДатыВремени for a specific культура, создай a $(LINK2 #Культура, Культура) for that культура и
 * retrieve its $(LINK2 #Культура_форматДатыВремени, форматДатыВремени) property. To создай a ФорматДатыВремени for the пользователь's текущ
 * культура, use the $(LINK2 #Culture_current, текущ) property.
 */
extern(D) class ФорматДатыВремени : ИСлужбаФормата
{
    /**
     * $(ANCHOR DateTimeFormat_ctor)
     * Initializes an экземпляр that is записываемый и культура-independent.
     */
    this();

    this(ДанныеОКультуре* данныеОКультуре, Календарь календарь);

    /**
     * $(ANCHOR DateTimeFormat_getFormat)
     * Retrieves an объект defining как в_ форматируй the specified тип.
     * Параметры: тип = The ИнфОТипе of the результатing formatting объект.
     * Возвращает: If тип is typeid(ФорматДатыВремени), the текущ ФорматДатыВремени экземпляр. Otherwise, пусто.
     * Примечания: Implements $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат).
     */
    public Объект дайФормат(ИнфОТипе тип);

    version(Clone)
    {
        /**
         */
        public Объект клонируй();
    }

    /**
     * $(ANCHOR DateTimeFormat_getAllDateTimePatterns)
     * Retrieves the стандарт образцы in which Время значения can be formatted.
     * Возвращает: An Массив of strings containing the стандарт образцы in which Время значения can be formatted.
     */
    public final ткст[] дайВсеОбразцыДатыВремени();

    /**
     * $(ANCHOR DateTimeFormat_getAllDateTimePatterns_char)
     * Retrieves the стандарт образцы in which Время значения can be formatted using the specified форматируй character.
     * Возвращает: An Массив of strings containing the стандарт образцы in which Время значения can be formatted using the specified форматируй character.
     */
    public final ткст[] дайВсеОбразцыДатыВремени(сим форматируй);

    /**
     * $(ANCHOR DateTimeFormat_getAbbreviatedDayName)
     * Retrieves the abbreviated имя указанного день of the week based on the культура of the экземпляр.
     * Параметры: ДеньНедели = Значение ДняНедели .
     * Возвращает: The abbreviated имя of день недели represented by ДеньНедели.
     */
    public final ткст дайСокращённоеИмяДня(Календарь.ДеньНедели деньНедели);

    /**
     * $(ANCHOR DateTimeFormat_getDayName)
     * Retrieves the full имя указанного день of the week based on the культура of the экземпляр.
     * Параметры: ДеньНедели = Значение ДняНедели .
     * Возвращает: The full имя of день недели represented by ДеньНедели.
     */
    public final ткст дайИмяДня(Календарь.ДеньНедели деньНедели);

    /**
     * $(ANCHOR DateTimeFormat_getAbbreviatedMonthName)
     * Retrieves the abbreviated имя указанного месяц based on the культура of the экземпляр.
     * Параметры: месяц = An целое between 1 и 13 indicating the имя of the _месяц в_ return.
     * Возвращает: The abbreviated имя of the _месяц represented by месяц.
     */
    public final ткст дайСокращённоеИмяМесяца(цел месяц);

    /**
     * $(ANCHOR DateTimeFormat_getMonthName)
     * Retrieves the full имя указанного месяц based on the культура of the экземпляр.
     * Параметры: месяц = An целое between 1 и 13 indicating the имя of the _месяц в_ return.
     * Возвращает: The full имя of the _месяц represented by месяц.
     */
    public final ткст дайИмяМесяца(цел месяц);

    /**
     * $(ANCHOR DateTimeFormat_getInstance)
     * Retrieves the ФорматДатыВремени for the specified ИСлужбаФормата.
     * Параметры: службаФормата = The ИСлужбаФормата использован в_ retrieve ФорматДатыВремени.
     * Возвращает: The ФорматДатыВремени for the specified ИСлужбаФормата.
     * Примечания: The метод calls $(LINK2 #ИСлужбаФормата_дайФормат, ИСлужбаФормата.дайФормат) with typeof(ФорматДатыВремени). If службаФормата is пусто,
     * then the значение of the текущ property is returned.
     */
    public static ФорматДатыВремени дайЭкземпляр(ИСлужбаФормата службаФормата);

    /**
     * $(ANCHOR DateTimeFormat_current)
     * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр из_ the текущ культура.
     * Возвращает: A читай-only ФорматДатыВремени экземпляр из_ the текущ культура.
     */
    public static ФорматДатыВремени текущ();

    /**
     * $(ANCHOR DateTimeFormat_invariantFormat)
     * $(I Property.) Retrieves a читай-only ФорматДатыВремени экземпляр that is culturally independent.
     * Возвращает: A читай-only ФорматДатыВремени экземпляр that is culturally independent.
     */
    public static ФорматДатыВремени инвариантныйФормат();

    /**
     * $(ANCHOR DateTimeFormat_isReadOnly)
     * $(I Property.) Retrieves a значение indicating whether the экземпляр is читай-only.
     * Возвращает: да is the экземпляр is читай-only; иначе, нет.
     */
    public final бул толькоЧтен_ли();

    /**
     * $(I Property.) Retrieves the Календарь использован by the текущ культура.
     * Возвращает: The Календарь determining the Календарь использован by the текущ культура. Например, the Грегориан.
     */
    public final Календарь календарь();
	
    /**
     * $(ANCHOR DateTimeFormat_Календарь)
     * $(I Property.) Assigns the Календарь в_ be использован by the текущ культура.
     * Параметры: значение = The Календарь determining the Календарь в_ be использован by the текущ культура.
     * Exceptions: If значение is not действителен for the текущ культура, an Исключение is thrown.
     */
    public final проц календарь(Календарь значение);

    /**
     * $(ANCHOR DateTimeFormat_firstДеньНедели)
     * $(I Property.) Retrieves первый день недели.
     * Возвращает: Значение ДняНедели  indicating первый день недели.
     */
    public final Календарь.ДеньНедели первыйДеньНед();
	
    /**
     * $(I Property.) Assigns первый день недели.
     * Параметры: valie = Значение ДняНедели  indicating первый день недели.
     */
    public final проц первыйДеньНед(Календарь.ДеньНедели значение);

    /**
     * $(ANCHOR DateTimeFormat_КалендарьWeekRule)
     * $(I Property.) Retrieves the _value indicating the правило использован в_ determine the первый week of the год.
     * Возвращает: A правилоНеделиКалендаря _value determining the первый week of the год.
     */
    public final Календарь.ПравилоНедели правилоНеделиКалендаря();
	
    /**
     * $(I Property.) Assigns the _value indicating the правило использован в_ determine the первый week of the год.
     * Параметры: значение = A правилоНеделиКалендаря _value determining the первый week of the год.
     */
    public final проц правилоНеделиКалендаря(Календарь.ПравилоНедели значение);

    /**
     * $(ANCHOR DateTimeFormat_nativeКалендарьName)
     * $(I Property.) Retrieves the исконный имя of the Календарь associated with the текущ экземпляр.
     * Возвращает: The исконный имя of the Календарь associated with the текущ экземпляр.
     */
    public final ткст исконноеНазваниеКалендаря();

    /**
     * $(ANCHOR DateTimeFormat_dateSeparator)
     * $(I Property.) Retrieves the ткст separating дата components.
     * Возвращает: The ткст separating дата components.
     */
    public final ткст разделительДаты();
	
    /**
     * $(I Property.) Assigns the ткст separating дата components.
     * Параметры: значение = The ткст separating дата components.
     */
    public final проц разделительДаты(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_timeSeparator)
     * $(I Property.) Retrieves the ткст separating время components.
     * Возвращает: The ткст separating время components.
     */
    public final ткст разделительВремени();
	
    /**
     * $(I Property.) Assigns the ткст separating время components.
     * Параметры: значение = The ткст separating время components.
     */
    public final проц разделительВремени(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_amDesignator)
     * $(I Property.) Retrieves the ткст designator for часы before noon.
     * Возвращает: The ткст designator for часы before noon. Например, "AM".
     */
    public final ткст определительДоПолудня();
	
    /**
     * $(I Property.) Assigns the ткст designator for часы before noon.
     * Параметры: значение = The ткст designator for часы before noon.
     */
    public final проц определительДоПолудня(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_pmDesignator)
     * $(I Property.) Retrieves the ткст designator for часы после noon.
     * Возвращает: The ткст designator for часы после noon. Например, "PM".
     */
    public final ткст определительПослеПолудня();
	
    /**
     * $(I Property.) Assigns the ткст designator for часы после noon.
     * Параметры: значение = The ткст designator for часы после noon.
     */
    public final проц определительПослеПолудня(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_shortDatePattern)
     * $(I Property.) Retrieves the форматируй образец for a крат дата значение.
     * Возвращает: The форматируй образец for a крат дата значение.
     */
    public final ткст краткийОбразецДаты();
    /**
     * $(I Property.) Assigns the форматируй образец for a крат дата _value.
     * Параметры: значение = The форматируй образец for a крат дата _value.
     */
    public final проц краткийОбразецДаты(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_shortTimePattern)
     * $(I Property.) Retrieves the форматируй образец for a крат время значение.
     * Возвращает: The форматируй образец for a крат время значение.
     */
    public final ткст краткийОбразецВремени();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a крат время _value.
     * Параметры: значение = The форматируй образец for a крат время _value.
     */
    public final проц краткийОбразецВремени(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_longDatePattern)
     * $(I Property.) Retrieves the форматируй образец for a дол дата значение.
     * Возвращает: The форматируй образец for a дол дата значение.
     */
    public final ткст длинныйОбразецДаты();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a дол дата _value.
     * Параметры: значение = The форматируй образец for a дол дата _value.
     */
    public final проц длинныйОбразецДаты(ткст значение);
    

    /**
     * $(ANCHOR DateTimeFormat_longTimePattern)
     * $(I Property.) Retrieves the форматируй образец for a дол время значение.
     * Возвращает: The форматируй образец for a дол время значение.
     */
    public final ткст длинныйОбразецВремени();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a дол время _value.
     * Параметры: значение = The форматируй образец for a дол время _value.
     */
    public final проц длинныйОбразецВремени(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_monthDayPattern)
     * $(I Property.) Retrieves the форматируй образец for a месяц и день значение.
     * Возвращает: The форматируй образец for a месяц и день значение.
     */
    public final ткст образецДняМесяца();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a месяц и день _value.
     * Параметры: значение = The форматируй образец for a месяц и день _value.
     */
    public final проц образецДняМесяца(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_yearMonthPattern)
     * $(I Property.) Retrieves the форматируй образец for a год и месяц значение.
     * Возвращает: The форматируй образец for a год и месяц значение.
     */
    public final ткст образецМесяцаГода();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a год и месяц _value.
     * Параметры: значение = The форматируй образец for a год и месяц _value.
     */
    public final проц образецМесяцаГода(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_abbreviatedDayNames)
     * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the дни of the week.
     * Возвращает: A ткст Массив containing the abbreviated names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
     *   this содержит "Sun", "Mon", "Tue", "Wed", "Thu", "Fri" и "Sat".
     */
    public final ткст[] сокращённыеИменаДней();
	
    /**
     * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the дни of the week.
     * Параметры: значение = A ткст Массив containing the abbreviated names of the дни of the week.
     */
    public final проц сокращённыеИменаДней(ткст[] значение);

    /**
     * $(ANCHOR DateTimeFormat_dayNames)
     * $(I Property.) Retrieves a ткст Массив containing the full names of the дни of the week.
     * Возвращает: A ткст Массив containing the full names of the дни of the week. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
     *   this содержит "Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница" и "Суббота".
     */
    public final ткст[] именаДней();
	
    /**
     * $(I Property.) Assigns a ткст Массив containing the full names of the дни of the week.
     * Параметры: значение = A ткст Массив containing the full names of the дни of the week.
     */
    public final проц именаДней(ткст[] значение);

    /**
     * $(ANCHOR DateTimeFormat_abbreviatedMonthNames)
     * $(I Property.) Retrieves a ткст Массив containing the abbreviated names of the месяцы.
     * Возвращает: A ткст Массив containing the abbreviated names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
     *   this содержит "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" и "".
     */
    public final ткст[] сокращённыеИменаМесяцев();
	
    /**
     * $(I Property.) Assigns a ткст Массив containing the abbreviated names of the месяцы.
     * Параметры: значение = A ткст Массив containing the abbreviated names of the месяцы.
     */
    public final проц сокращённыеИменаМесяцев(ткст[] значение);

    /**
     * $(ANCHOR DateTimeFormat_monthNames)
     * $(I Property.) Retrieves a ткст Массив containing the full names of the месяцы.
     * Возвращает: A ткст Массив containing the full names of the месяцы. For $(LINK2 #DateTimeFormat_invariantFormat, инвариантныйФормат),
     *   this содержит "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" и "".
     */
    public final ткст[] именаМесяцев();
	
    /**
     * $(I Property.) Assigns a ткст Массив containing the full names of the месяцы.
     * Параметры: значение = A ткст Массив containing the full names of the месяцы.
     */
    public final проц именаМесяцев(ткст[] значение);

    /**
     * $(ANCHOR DateTimeFormat_ПолнаяДатаTimePattern)
     * $(I Property.) Retrieves the форматируй образец for a дол дата и a дол время значение.
     * Возвращает: The форматируй образец for a дол дата и a дол время значение.
     */
    public final ткст полныйОбразецДатыВремени();
	
    /**
     * $(I Property.) Assigns the форматируй образец for a дол дата и a дол время _value.
     * Параметры: значение = The форматируй образец for a дол дата и a дол время _value.
     */
    public final проц полныйОбразецДатыВремени(ткст значение);

    /**
     * $(ANCHOR DateTimeFormat_rfc1123Pattern)
     * $(I Property.) Retrieves the форматируй образец based on the IETF RFC 1123 specification, for a время значение.
     * Возвращает: The форматируй образец based on the IETF RFC 1123 specification, for a время значение.
     */
    public final ткст образецРФС1123();

    /**
     * $(ANCHOR DateTimeFormat_sortableDateTimePattern)
     * $(I Property.) Retrieves the форматируй образец for a sortable дата и время значение.
     * Возвращает: The форматируй образец for a sortable дата и время значение.
     */
    public final ткст сортируемыйОбразецДатыВремени();

    /**
     * $(ANCHOR DateTimeFormat_universalSortableDateTimePattern)
     * $(I Property.) Retrieves the форматируй образец for a universal дата и время значение.
     * Возвращает: The форматируй образец for a universal дата и время значение.
     */
    public final ткст универсальныйСортируемыйОбразецДатыВремени();

}

static Культура культура;

static this()
{
культура = new Культура("ru-RU");
}


