module lib.OpenGL;
pragma(lib, "DinrusArcX86DLL.lib");

alias бцел      Гперечень, GLenum, GLuint;
alias байт      Гбайт, GLbyte;
alias ббайт     Гбул, Гббайт, GLboolean, GLubyte;
alias бцел      Гбитполе, GLbitfield;
alias проц      Гпроц, GLvoid;
alias цел       Гцел, Гцразм, GLint, GLsizei;
alias плав      Гплав, Гклампп, GLfloat, GLclampf;
alias дво       Гдво, Гклампд, GLdouble, GLclampd;
alias крат      Гкрат, GLshort;
alias бкрат     Гбкрат, GLushort;
alias т_дельтаук Гцелук, GLintptr;
alias т_дельтаук Гцразмук, GLsizeiptr;
alias сим       Гсим, GLchar;

// Boolean values
enum : GLboolean
{
    GL_FALSE    = 0x0,
    GL_TRUE    = 0x1,
}

// Булевы значения
enum : Гбул
{
    г_нет    = 0x0,
    г_да    = 0x1,
}

struct Нурб{} alias Нурб GLUnurbs;
struct Квадр{} alias  Квадр GLUquadric;
struct Тесс{} alias Тесс GLUtesselator;

typedef GLUnurbs GLUnurbsObj;
typedef GLUquadric GLUquadricObj;
typedef GLUtesselator GLUtesselatorObj;
typedef GLUtesselator GLUtriangulatorObj;

alias extern (Windows) проц function() винфунк;

alias extern(D) проц function() дфунк;
alias extern(D) проц function(цел) дфунк_Ц;
alias extern(D) проц function(цел, цел) дфунк_ЦЦ;
alias extern(D) проц function(цел, цел, цел) дфунк_ЦЦЦ;
alias extern(D) проц function(цел, цел, цел, цел) дфунк_ЦЦЦЦ;
alias extern(D) проц function(цел, цел, цел, цел, цел) дфунк_ЦЦЦЦЦ;
alias extern(D) проц function(сим, цел, цел) дфунк_СЦЦ;
alias extern(D) проц function(ббайт, цел, цел) дфунк_бБЦЦ;
alias extern(D) проц function(ук) дфунк_У;
alias extern(D) проц function(бцел, цел, цел, цел) дфунк_бЦЦЦЦ; 

alias extern(D) цел function() дфункЦ; 
alias extern(D) цел function(сим, цел, цел) дфункЦ_СЦЦ;
alias extern(D) цел function(ббайт, цел, цел) дфункЦ_бБЦЦ;
alias extern(D) цел function(цел) дфункЦ_Ц;
alias extern(D) цел function(цел, цел) дфункЦ_ЦЦ;
alias extern(D) цел function(цел, цел, цел) дфункЦ_ЦЦЦ;
alias extern(D) цел function(цел, цел, цел, цел) дфункЦ_ЦЦЦЦ;
alias extern(D) цел function (ук, бцел, бцел, цел) дфункЦ_УбЦбЦЦ;

alias extern(D) бцел function() дфункбЦ; 
alias extern(D) бцел function (ук, бцел, бцел, цел) дфункбЦ_УбЦбЦЦ;
alias extern(D)  бцел function(ук) дфункбЦ_У;

alias extern(D) дво  function() дфункД2; 
alias extern(D) плав  function() дфункП; 
alias extern(D) ук   function() дфункУ; 
alias extern(D) байт  function() дфункБ; 
alias extern(D) ббайт  function() дфункбБ; 
alias extern(D) сим  function() дфункС; 
alias extern(D) усим function() дфункуС;
alias extern(D) шим  function() дфункШ;
alias extern(D) ушим function() дфункуШ;
alias extern(D) дол  function() дфункД;
alias extern(D) бдол  function() дфункбД;

alias extern(D) бул  function() дфункБ2;
alias extern(D) бул function(бцел) дфункБ2_бЦ;

enum : Гперечень
{
	
    // Типы данных
	
    БАЙТ                                = 0x1400,
    ББАЙТ                       = 0x1401,
    КРАТ                               = 0x1402,
    БКРАТ                      = 0x1403,
    ЦЕЛ                                 = 0x1404,
    БЦЕЛ                        = 0x1405,
    ПЛАВ                               = 0x1406,
    ДВО                              = 0x140A,
    ДВА_БАЙТА                             = 0x1407,
    ТРИ_БАЙТА                             = 0x1408,
    ЧЕТЫРЕ_БАЙТА                             = 0x1409,
	//English
	GL_BYTE				= 0x1400,
	GL_UNSIGNED_BYTE			= 0x1401,
	GL_SHORT				= 0x1402,
	GL_UNSIGNED_SHORT			= 0x1403,
	GL_INT				= 0x1404,
	GL_UNSIGNED_INT			= 0x1405,
	GL_FLOAT				= 0x1406,
	GL_DOUBLE				= 0x140A,
	GL_2_BYTES				= 0x1407,
	GL_3_BYTES				= 0x1408,
	GL_4_BYTES         = 0x1409,

    // Простые фигуры
    ТОЧКИ                              = 0x0000,
    ЛИНИИ                               = 0x0001,
    ПЕТЛЯ                           = 0x0002,
    СВЯЗКА_ЛИНИЙ                          = 0x0003,
    ТРЕУГОЛЬНИКИ                           = 0x0004,
    СВЯЗКА_ТРЕУГОЛЬНИКОВ                      = 0x0005,
    ВЕЕР_ТРЕУГОЛЬНИКОВ                        = 0x0006,
    КВАДРАТЫ                               = 0x0007,
    СВЯЗКА_КВАДРАТОВ                          = 0x0008,
    МНОГОУГОЛЬНИК                             = 0x0009,
	//English
	GL_POINTS				= 0x0000,
	GL_LINES				= 0x0001,
	GL_LINE_LOOP			= 0x0002,
	GL_LINE_STRIP			= 0x0003,
	GL_TRIANGLES			= 0x0004,
	GL_TRIANGLE_STRIP			= 0x0005,
	GL_TRIANGLE_FAN			= 0x0006,
	GL_QUADS				= 0x0007,
	GL_QUAD_STRIP			= 0x0008,
	GL_POLYGON				= 0x0009,

    // Массивы вершин
    МАССИВ_ВЕРШИН                        = 0x8074,
    МАССИВ_НОРМАЛЕЙ                        = 0x8075,
    МАССИВ_ЦВЕТОВ                         = 0x8076,
    МАССИВ_ИНДЕКСОВ                         = 0x8077,
    МАССИВ_ККОРДИНАТ_ТЕКСТУР                 = 0x8078,
    МАССИВ_ФЛАГОВ_КРАЯ                     = 0x8079,
    РАЗМЕР_МАССИВА_ВЕРШИН                   = 0x807A,
    ТИП_МАССИВА_ВЕРШИН                   = 0x807B,
    ШАГ_МАССИВА_ВЕРШИН                 = 0x807C,
    ТИП_МАССИВА_НОРМАЛЕЙ                   = 0x807E,
    ШАГ_МАССИВА_НОРМАЛЕЙ                 = 0x807F,
    РАЗМЕР_МАССИВА_ЦВЕТА                    = 0x8081,
    ТИП_МАССИВА_ЦВЕТА                    = 0x8082,
    ШАГ_МАССИВА_ЦВЕТОВ                  = 0x8083,
    ТИП_МАССИВА_ИНДЕКСОВ                    = 0x8085,
    ШАГ_МАССИВА_ИНДЕКСОВ                  = 0x8086,
    РАЗМЕР_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8088,
    ТИП_МАССИВА_КООРД_ТЕКСТУРЫ            = 0x8089,
    ШАГ_МАССИВА_КООРД_ТЕКСТУР          = 0x808A,
    ШАГ_МАССИВА_ФЛАГОВ_КРАЯ              = 0x808C,
    УК_НА_МАССИВ_ВЕРШИН                = 0x808E,
    УК_НА_МАССИВ_НОРМАЛЕЙ                = 0x808F,
   УК_НА_МАССИВ_ЦВЕТА                 = 0x8090,
    УК_НА_МАССИВ_ИНДЕКСОВ                 = 0x8091,
    УК_НА_МАССИВ_КООРД_ТЕКСТУРЫ         = 0x8092,
    УК_НА_МАССИВ_ФЛАГОВ_КРАЯ             = 0x8093,
    V2F                                 = 0x2A20,
    V3F                                 = 0x2A21,
    C4UB_V2F                            = 0x2A22,
    C4UB_V3F                            = 0x2A23,
    C3F_V3F                             = 0x2A24,
    N3F_V3F                             = 0x2A25,
    C4F_N3F_V3F                         = 0x2A26,
    T2F_V3F                             = 0x2A27,
    T4F_V4F                             = 0x2A28,
    T2F_C4UB_V3F                        = 0x2A29,
    T2F_C3F_V3F                         = 0x2A2A,
    T2F_N3F_V3F                         = 0x2A2B,
    T2F_C4F_N3F_V3F                     = 0x2A2C,
    T4F_C4F_N3F_V4F                     = 0x2A2D,
	//English
	GL_VERTEX_ARRAY			= 0x8074,
	GL_NORMAL_ARRAY			= 0x8075,
	GL_COLOR_ARRAY			= 0x8076,
	GL_INDEX_ARRAY			= 0x8077,
	GL_TEXTURE_COORD_ARRAY		= 0x8078,
	GL_EDGE_FLAG_ARRAY			= 0x8079,
	GL_VERTEX_ARRAY_SIZE		= 0x807A,
	GL_VERTEX_ARRAY_TYPE		= 0x807B,
	GL_VERTEX_ARRAY_STRIDE		= 0x807C,
	GL_NORMAL_ARRAY_TYPE		= 0x807E,
	GL_NORMAL_ARRAY_STRIDE		= 0x807F,
	GL_COLOR_ARRAY_SIZE		= 0x8081,
	GL_COLOR_ARRAY_TYPE		= 0x8082,
	GL_COLOR_ARRAY_STRIDE		= 0x8083,
	GL_INDEX_ARRAY_TYPE		= 0x8085,
	GL_INDEX_ARRAY_STRIDE		= 0x8086,
	GL_TEXTURE_COORD_ARRAY_SIZE	= 0x8088,
	GL_TEXTURE_COORD_ARRAY_TYPE	= 0x8089,
	GL_TEXTURE_COORD_ARRAY_STRIDE	= 0x808A,
	GL_EDGE_FLAG_ARRAY_STRIDE		= 0x808C,
	GL_VERTEX_ARRAY_POINTER		= 0x808E,
	GL_NORMAL_ARRAY_POINTER		= 0x808F,
	GL_COLOR_ARRAY_POINTER		= 0x8090,
	GL_INDEX_ARRAY_POINTER		= 0x8091,
	GL_TEXTURE_COORD_ARRAY_POINTER	= 0x8092,
	GL_EDGE_FLAG_ARRAY_POINTER		= 0x8093,
	GL_V2F				= 0x2A20,
	GL_V3F				= 0x2A21,
	GL_C4UB_V2F			= 0x2A22,
	GL_C4UB_V3F			= 0x2A23,
	GL_C3F_V3F				= 0x2A24,
	GL_N3F_V3F				= 0x2A25,
	GL_C4F_N3F_V3F			= 0x2A26,
	GL_T2F_V3F				= 0x2A27,
	GL_T4F_V4F				= 0x2A28,
	GL_T2F_C4UB_V3F			= 0x2A29,
	GL_T2F_C3F_V3F			= 0x2A2A,
	GL_T2F_N3F_V3F			= 0x2A2B,
	GL_T2F_C4F_N3F_V3F			= 0x2A2C,
	GL_T4F_C4F_N3F_V4F			= 0x2A2D,

    // Матричный режим
    РЕЖИМ_МАТРИЦЫ                         = 0x0BA0,
    ОБЗОР_МОДЕЛИ                           = 0x1700,
    ПРОЕКЦИЯ                          = 0x1701,
    ТЕКСТУРА                             = 0x1702,
	//English
	GL_MATRIX_MODE			= 0x0BA0,
	GL_MODELVIEW			= 0x1700,
	GL_PROJECTION			= 0x1701,
	GL_TEXTURE				= 0x1702,

    // Точки
    СМЯГЧЕНИЕ_ТОЧКИ                        = 0x0B10,
    РАЗМЕР_ТОЧКИ                          = 0x0B11,
    ГРАНУЛЯРНОСТЬ_РАЗМЕРА_ТОЧКИ              = 0x0B13,
    ДИАПАЗОН_РАЗМЕРА_ТОЧКИ                    = 0x0B12,
	//English
	GL_POINT_SMOOTH			= 0x0B10,
	GL_POINT_SIZE			= 0x0B11,
	GL_POINT_SIZE_GRANULARITY		= 0x0B13,
	GL_POINT_SIZE_RANGE		= 0x0B12,

    // Линии
    СМЯГЧЕНИЕ_ЛИНИИ                         = 0x0B20,
    УЗОР_ЛИНИЙ                        = 0x0B24,
    ОБРАЗЕЦ_УЗОРА_ЛИНИЙ                = 0x0B25,
    ПОВТОР_УЗОРА_ЛИНИЙ                 = 0x0B26,
    ШИРИНА_ЛИНИИ                          = 0x0B21,
    ГРАНУЛЯРНОСТЬ_ШИРИНЫ_ЛИНИИ              = 0x0B23,
    ДИАПАЗОН_ШИРИНЫ_ЛИНИИ                    = 0x0B22,
	//English
	GL_LINE_SMOOTH			= 0x0B20,
	GL_LINE_STIPPLE			= 0x0B24,
	GL_LINE_STIPPLE_PATTERN		= 0x0B25,
	GL_LINE_STIPPLE_REPEAT		= 0x0B26,
	GL_LINE_WIDTH			= 0x0B21,
	GL_LINE_WIDTH_GRANULARITY		= 0x0B23,
	GL_LINE_WIDTH_RANGE		= 0x0B22,

    // Многоугольники
    ТОЧКА                               = 0x1B00,
    ЛИНИЯ                                = 0x1B01,
    ЗАЛИВКА                                = 0x1B02,
    CW                                  = 0x0900,
    CCW                                 = 0x0901,
    ФРОНТ                               = 0x0404,
    ТЫЛ                                = 0x0405,
    РЕЖИМ_МНОГОУГ                        = 0x0B40,
    СМЯГЧЕНИЕ_МНОГОУГ                      = 0x0B41,
    УЗОР_МНОГОУГ                     = 0x0B42,
    ФЛАГ_КРАЯ                           = 0x0B43,
    ПРОФИЛЬ                           = 0x0B44,
    РЕЖИМ_ПРОФИЛЬ                      = 0x0B45,
    ФАС                          = 0x0B46,
    ФАКТОР_СМЕЩЕНИЯ_МНОГОУГ               = 0x8038,
    ЕДИНИЦЫ_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A00,
    ТОЧКА_СМЕЩЕНИЯ_МНОГОУГ                = 0x2A01,
    ЛИНИЯ_СМЕЩЕНИЯ_МНОГОУГ                 = 0x2A02,
    ЗАЛИВКА_СМЕЩЕНИЯ_МНОГОУГ                 = 0x8037,
	//English
	GL_POINT				= 0x1B00,
	GL_LINE				= 0x1B01,
	GL_FILL				= 0x1B02,
	GL_CW				= 0x0900,
	GL_CCW				= 0x0901,
	GL_FRONT				= 0x0404,
	GL_BACK				= 0x0405,
	GL_POLYGON_MODE			= 0x0B40,
	GL_POLYGON_SMOOTH			= 0x0B41,
	GL_POLYGON_STIPPLE			= 0x0B42,
	GL_EDGE_FLAG			= 0x0B43,
	GL_CULL_FACE			= 0x0B44,
	GL_CULL_FACE_MODE			= 0x0B45,
	GL_FRONT_FACE			= 0x0B46,
	GL_POLYGON_OFFSET_FACTOR		= 0x8038,
	GL_POLYGON_OFFSET_UNITS		= 0x2A00,
	GL_POLYGON_OFFSET_POINT		= 0x2A01,
	GL_POLYGON_OFFSET_LINE		= 0x2A02,
	GL_POLYGON_OFFSET_FILL		= 0x8037,

    // Списки отображения
    КОМПИЛИРУЙ                             = 0x1300,
    КОМПИЛИРУЙ_И_ВЫПОЛНИ                 = 0x1301,
    БАЗА_СПИСКА                           = 0x0B32,
    ИНДЕКС_СПИСКА                         = 0x0B33,
    РЕЖИМ_СПИСКА                           = 0x0B30,
	//English
	GL_COMPILE				= 0x1300,
	GL_COMPILE_AND_EXECUTE		= 0x1301,
	GL_LIST_BASE			= 0x0B32,
	GL_LIST_INDEX			= 0x0B33,
	GL_LIST_MODE			= 0x0B30,

    // Буфер глубины
    НИКОГДА                               = 0x0200,
    МЕНЬШЕ                                = 0x0201,
    РАВНЫЙ                               = 0x0202,
    МИЛИР                              = 0x0203,
    БОЛЬШЕ                             = 0x0204,
    НЕРАВН                            = 0x0205,
    БИЛИР                              = 0x0206,
    ВСЕГДА                              = 0x0207,
    ТЕСТ_ДАЛИ                          = 0x0B71,
    БИТЫ_ДАЛИ                          = 0x0D56,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ДАЛИ                   = 0x0B73,
    ФУНКЦ_ДАЛИ                          = 0x0B74,
    ДИАПАЗОН_ДАЛИ                         = 0x0B70,
    МАСКА_ЗАПИСИ_ДАЛИ                     = 0x0B72,
    КОМПОНЕНТА_ДАЛИ                     = 0x1902,
	//English
	GL_NEVER				= 0x0200,
	GL_LESS				= 0x0201,
	GL_EQUAL				= 0x0202,
	GL_LEQUAL				= 0x0203,
	GL_GREATER				= 0x0204,
	GL_NOTEQUAL			= 0x0205,
	GL_GEQUAL				= 0x0206,
	GL_ALWAYS				= 0x0207,
	GL_DEPTH_TEST			= 0x0B71,
	GL_DEPTH_BITS			= 0x0D56,
	GL_DEPTH_CLEAR_VALUE		= 0x0B73,
	GL_DEPTH_FUNC			= 0x0B74,
	GL_DEPTH_RANGE			= 0x0B70,
	GL_DEPTH_WRITEMASK			= 0x0B72,
	GL_DEPTH_COMPONENT			= 0x1902,

    // Освещение
    ОСВЕЩЕНИЕ                            = 0x0B50,
    СВЕТ0                              = 0x4000,
    СВЕТ1                              = 0x4001,
    СВЕТ2                              = 0x4002,
    СВЕТ3                              = 0x4003,
    СВЕТ4                              = 0x4004,
    СВЕТ5                              = 0x4005,
    СВЕТ6                              = 0x4006,
    СВЕТ7                              = 0x4007,
    ЭКСПОНЕНТА_ПРОЖЕКТОРА                       = 0x1205,
    ОБРЕЗКА_ПРОЖЕКТОРА                         = 0x1206,
    ПОСТОЯННОЕ_ЗАТЕНЕНИЕ                = 0x1207,
    ЛИНЕЙНОЕ_ЗАТЕНЕНИЕ                  = 0x1208,
    КВАДРАТИЧНОЕ_ЗАТЕНЕНИЕ               = 0x1209,
    АМБЬЕНТНЫЙ                             = 0x1200,
    ДИФФУЗНЫЙ                             = 0x1201,
    СПЕКУЛЯРНЫЙ                            = 0x1202,
    БЛЕСК                           = 0x1601,
    ЭМИССИЯ                            = 0x1600,
    ПОЗИЦИЯ                            = 0x1203,
    НАПРАВЛЕНИЕ_ПРОЖЕКТОРА                      = 0x1204,
    АМБЬЕНТНО_ДИФФУЗНЫЙ                 = 0x1602,
    ИНДЕКСЫ_ЦВЕТА                       = 0x1603,
    ДВУСТОРОННЯЯ_СВЕТОМОДЕЛЬ                = 0x0B52,
    ЛОКАЛЬНЫЙ_ОБОЗРЕВАТЕЛЬ_СВЕТОМОДЕЛИ            = 0x0B51,
    АМБЬЕНТНАЯ_СВЕТОМОДЕЛЬ                 = 0x0B53,
    ФРОНТ_И_ТЫЛ                      = 0x0408,
    МОДЕЛЬ_ТЕНИ                         = 0x0B54,
    ПЛОСКИЙ                                = 0x1D00,
    ГЛАДКИЙ                              = 0x1D01,
    ЦВЕТОМАТЕРИАЛ                      = 0x0B57,
    ФАС_ЦВЕТОМАТЕРИАЛА                 = 0x0B55,
    ПАРАМЕТР_ЦВЕТОМАТЕРИАЛА            = 0x0B56,
    НОРМАЛИЗУЙ                           = 0x0BA1,
	//English
	GL_LIGHTING			= 0x0B50,
	GL_LIGHT0				= 0x4000,
	GL_LIGHT1				= 0x4001,
	GL_LIGHT2				= 0x4002,
	GL_LIGHT3				= 0x4003,
	GL_LIGHT4				= 0x4004,
	GL_LIGHT5				= 0x4005,
	GL_LIGHT6				= 0x4006,
	GL_LIGHT7				= 0x4007,
	GL_SPOT_EXPONENT			= 0x1205,
	GL_SPOT_CUTOFF			= 0x1206,
	GL_CONSTANT_ATTENUATION		= 0x1207,
	GL_LINEAR_ATTENUATION		= 0x1208,
	GL_QUADRATIC_ATTENUATION		= 0x1209,
	GL_AMBIENT				= 0x1200,
	GL_DIFFUSE				= 0x1201,
	GL_SPECULAR			= 0x1202,
	GL_SHININESS			= 0x1601,
	GL_EMISSION			= 0x1600,
	GL_POSITION			= 0x1203,
	GL_SPOT_DIRECTION			= 0x1204,
	GL_AMBIENT_AND_DIFFUSE		= 0x1602,
	GL_COLOR_INDEXES			= 0x1603,
	GL_LIGHT_MODEL_TWO_SIDE		= 0x0B52,
	GL_LIGHT_MODEL_LOCAL_VIEWER	= 0x0B51,
	GL_LIGHT_MODEL_AMBIENT		= 0x0B53,
	GL_FRONT_AND_BACK			= 0x0408,
	GL_SHADE_MODEL			= 0x0B54,
	GL_FLAT				= 0x1D00,
	GL_SMOOTH				= 0x1D01,
	GL_COLOR_MATERIAL			= 0x0B57,
	GL_COLOR_MATERIAL_FACE		= 0x0B55,
	GL_COLOR_MATERIAL_PARAMETER	= 0x0B56,
	GL_NORMALIZE			= 0x0BA1,

    // Плоскости обрезки пользователя
    ПЛОСКОСТЬ_ОБРЕЗКИ0                         = 0x3000,
    ПЛОСКОСТЬ_ОБРЕЗКИ1                         = 0x3001,
    ПЛОСКОСТЬ_ОБРЕЗКИ2                         = 0x3002,
    ПЛОСКОСТЬ_ОБРЕЗКИ3                         = 0x3003,
    ПЛОСКОСТЬ_ОБРЕЗКИ4                         = 0x3004,
    ПЛОСКОСТЬ_ОБРЕЗКИ5                         = 0x3005,
	//English
	GL_CLIP_PLANE0			= 0x3000,
	GL_CLIP_PLANE1			= 0x3001,
	GL_CLIP_PLANE2			= 0x3002,
	GL_CLIP_PLANE3			= 0x3003,
	GL_CLIP_PLANE4			= 0x3004,
	GL_CLIP_PLANE5			= 0x3005,

    // Буфер накопления
    АККУМ_КРАСНЫЕ_БИТЫ                      = 0x0D58,
    АККУМ_ЗЕЛЁНЫЕ_БИТЫ                    = 0x0D59,
    АККУМ_СИНИЕ_БИТЫ                     = 0x0D5A,
    АККУМ_АЛЬФА_БИТЫ                    = 0x0D5B,
    АККУМ_ЗНАЧЕНИЕ_ОЧИСТКИ                   = 0x0B80,
    АККУМ                               = 0x0100,
    ДОБАВЬ                                 = 0x0104,
    ЗАГРУЗИ                                = 0x0101,
    МУЛЬТ                                = 0x0103,
    ВЕРНИ                              = 0x0102,
	//English
	GL_ACCUM_RED_BITS			= 0x0D58,
	GL_ACCUM_GREEN_BITS		= 0x0D59,
	GL_ACCUM_BLUE_BITS			= 0x0D5A,
	GL_ACCUM_ALPHA_BITS		= 0x0D5B,
	GL_ACCUM_CLEAR_VALUE		= 0x0B80,
	GL_ACCUM				= 0x0100,
	GL_ADD				= 0x0104,
	GL_LOAD				= 0x0101,
	GL_MULT				= 0x0103,
	GL_RETURN				= 0x0102,

    // Тестирование прозрачности
    АЛЬФАТЕСТ                          = 0x0BC0,
    АЛЬФАТЕСТРЕФ                      = 0x0BC2,
    АЛЬФАТЕСТФУНКЦ                     = 0x0BC1,
	//English
	GL_ALPHA_TEST			= 0x0BC0,
	GL_ALPHA_TEST_REF			= 0x0BC2,
	GL_ALPHA_TEST_FUNC			= 0x0BC1,

    // Смешивание
    СМЕСЬ                               = 0x0BE2,
    ИСТОЧНИК_СМЕШИВАНИЯ                           = 0x0BE1,
    ПРИЁМНИК_СМЕШИВАНИЯ                           = 0x0BE0,
    НОЛЬ                                = 0x0,
    ОДИН                                 = 0x1,
    ЦВЕТ_ИСТОЧНИКА                           = 0x0300,
    ОДИН_МИНУС_ЦВЕТ_ИСТОЧНИКА                 = 0x0301,
    АЛЬФА_ИСТОЧНИКА                           = 0x0302,
    ОДИН_МИНУС_АЛЬФА_ИСТОЧНИКА                 = 0x0303,
    АЛЬФА_ПРЁМНИКА                           = 0x0304,
    ОДИН_МИНУС_АЛЬФА_ПРИЁМНИКА                 = 0x0305,
    ЦВЕТ_ПРИЁМНИКА                           = 0x0306,
    ОДИН_МИНУС_ЦВЕТ_ПРИЁМНИКА                 = 0x0307,
    НАСЫТЬ_АЛЬФУ_ИСТОЧНИКА                  = 0x0308,
	//English
	GL_BLEND				= 0x0BE2,
	GL_BLEND_SRC			= 0x0BE1,
	GL_BLEND_DST			= 0x0BE0,
	GL_ZERO				= 0x0,
	GL_ONE				= 0x1,
	GL_SRC_COLOR			= 0x0300,
	GL_ONE_MINUS_SRC_COLOR		= 0x0301,
	GL_SRC_ALPHA			= 0x0302,
	GL_ONE_MINUS_SRC_ALPHA		= 0x0303,
	GL_DST_ALPHA			= 0x0304,
	GL_ONE_MINUS_DST_ALPHA		= 0x0305,
	GL_DST_COLOR			= 0x0306,
	GL_ONE_MINUS_DST_COLOR		= 0x0307,
	GL_SRC_ALPHA_SATURATE		= 0x0308,
    
    // Режим показа
    ФИДБЭК                            = 0x1C01,
    ОТОБРАЗИ                              = 0x1C00,
    ВЫДЕЛИ                              = 0x1C02,
	//English
	GL_FEEDBACK			= 0x1C01,
	GL_RENDER				= 0x1C00,
	GL_SELECT				= 0x1C02,

    // Фидбэк
    М2                                  = 0x0600,
    М3                                  = 0x0601,
    М3_ЦВЕТ                            = 0x0602,
    М3_ТЕКСТУРА_ЦВЕТА                    = 0x0603,
    М4_ТЕКСТУРА_ЦВЕТА                    = 0x0604,
    ЗНАК_ТОЧКИ                         = 0x0701,
    ЗНАК_ЛИНИИ                          = 0x0702,
    ЗНАК_ВОССТАНОВЛЕНИЯ_ЛИНИИ                    = 0x0707,
    ЗНАК_МНОГОУГ                       = 0x0703,
    ЗНАК_БИТМАПА                        = 0x0704,
    ЗНАК_РИСОВАНИЯ_ПИКСЕЛЯ                    = 0x0705,
    ЗНАК_КОПИРОВАНИЯ_ПИКСЕЛЯ                    = 0x0706,
    ЗНАК_ПРОПУСКА                  = 0x0700,
    УК_НА_БУФЕР_ФИДБЭКА             = 0x0DF0,
    РАЗМЕР_БУФЕРА_ФИДБЭКА                = 0x0DF1,
    ТИП_БУФЕРА_ФИДБЭКА                = 0x0DF2,
	//English
	GL_2D				= 0x0600,
	GL_3D				= 0x0601,
	GL_3D_COLOR			= 0x0602,
	GL_3D_COLOR_TEXTURE		= 0x0603,
	GL_4D_COLOR_TEXTURE		= 0x0604,
	GL_POINT_TOKEN			= 0x0701,
	GL_LINE_TOKEN			= 0x0702,
	GL_LINE_RESET_TOKEN		= 0x0707,
	GL_POLYGON_TOKEN			= 0x0703,
	GL_BITMAP_TOKEN			= 0x0704,
	GL_DRAW_PIXEL_TOKEN		= 0x0705,
	GL_COPY_PIXEL_TOKEN		= 0x0706,
	GL_PASS_THROUGH_TOKEN		= 0x0700,
	GL_FEEDBACK_BUFFER_POINTER		= 0x0DF0,
	GL_FEEDBACK_BUFFER_SIZE		= 0x0DF1,
	GL_FEEDBACK_BUFFER_TYPE		= 0x0DF2,

    // Выделение
    УК_НА_БУФЕР_ВЫБОРА            = 0x0DF3,
    РАЗМЕР_БУФЕРА_ВЫБОРА               = 0x0DF4,
	//English
	GL_SELECTION_BUFFER_POINTER	= 0x0DF3,
	GL_SELECTION_BUFFER_SIZE		= 0x0DF4,

    // Туман
    ТУМАН                                 = 0x0B60,
    РЕЖИМ_ТУМАНА                            = 0x0B65,
    ПЛОТНОСТЬ_ТУМАНА                         = 0x0B62,
    ЦВЕТ_ТУМАНА                           = 0x0B66,
    ИНДЕКС_ТУМАНА                           = 0x0B61,
    СТАРТ_ТУМАНА                           = 0x0B63,
    КОНЕЦ_ТУМАНА                             = 0x0B64,
    ЛИНЕЙНЫЙ                              = 0x2601,
    ЭКСП                                 = 0x0800,
    ЭКСП2                                = 0x0801,
	//English
	GL_FOG				= 0x0B60,
	GL_FOG_MODE			= 0x0B65,
	GL_FOG_DENSITY			= 0x0B62,
	GL_FOG_COLOR			= 0x0B66,
	GL_FOG_INDEX			= 0x0B61,
	GL_FOG_START			= 0x0B63,
	GL_FOG_END				= 0x0B64,
	GL_LINEAR				= 0x2601,
	GL_EXP				= 0x0800,
	GL_EXP2				= 0x0801,

    // Логические операции
    ЛОГОП                            = 0x0BF1,
    ИНДЕКСНАЯ_ЛОГОП                      = 0x0BF1,
    ЦВЕТОВАЯ_ЛОГОП                      = 0x0BF2,
    РЕЖИМ_ЛОГОП                       = 0x0BF0,
    ОЧИСТИ                               = 0x1500,
    УСТАНОВИ                                 = 0x150F,
    КОПИРУЙ                                = 0x1503,
    КОПИРУЙ_ИНВ                       = 0x150C,
    НЕТОП                                = 0x1505,
    ИНВЕРТИРУЙ                              = 0x150A,
    И                                 = 0x1501,
    НИ                                = 0x150E,
    ИЛИ                                  = 0x1507,
    НИЛИ                                 = 0x1508,
    ИИЛИ                                 = 0x1506,
    ЭКВИВ                               = 0x1509,
    И_РЕВ                         = 0x1502,
    И_ИНВ                        = 0x1504,
    ИЛИ_РЕВ                         = 0x150B,
    ИЛИ_ИНВ                         = 0x150D,
	//English
	GL_LOGIC_OP			= 0x0BF1,
	GL_INDEX_LOGIC_OP			= 0x0BF1,
	GL_COLOR_LOGIC_OP			= 0x0BF2,
	GL_LOGIC_OP_MODE			= 0x0BF0,
	GL_CLEAR				= 0x1500,
	GL_SET				= 0x150F,
	GL_COPY				= 0x1503,
	GL_COPY_INVERTED			= 0x150C,
	GL_NOOP				= 0x1505,
	GL_INVERT				= 0x150A,
	GL_AND				= 0x1501,
	GL_NAND				= 0x150E,
	GL_OR				= 0x1507,
	GL_NOR				= 0x1508,
	GL_XOR				= 0x1506,
	GL_EQUIV				= 0x1509,
	GL_AND_REVERSE			= 0x1502,
	GL_AND_INVERTED			= 0x1504,
	GL_OR_REVERSE			= 0x150B,
	GL_OR_INVERTED			= 0x150D,

    // Шаблон
    ТЕСТ_ШАБЛОНА                        = 0x0B90,
    МАСКА_ЗАПИСИ_ШАБЛОНА                   = 0x0B98,
    БИТЫ_ШАБЛОНА                        = 0x0D57,
    ФУНКЦ_ШАБЛОНА                        = 0x0B92,
    МАСКА_ЗНАЧЕНИЯ_ШАБЛОНА                  = 0x0B93,
    РЕФ_НА_ШАБЛОН                         = 0x0B97,
    СБОЙ_ШАБЛОНА                        = 0x0B94,
    ПРОХОД_ШАБЛОНА_ПРОХОД_ДАЛИ             = 0x0B96,
    ПРОХОД_ШАБЛОНА_СБОЙ_ДАЛИ             = 0x0B95,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ШАБЛОНА                 = 0x0B91,
    ИНДЕКС_ШАБЛОНА                       = 0x1901,
    СОХРАНИ                                = 0x1E00,
    ЗАМЕНИ                             = 0x1E01,
    УВЕЛИЧЬ                                = 0x1E02,
    УМЕНЬШИ                                = 0x1E03,
	//English
	GL_STENCIL_TEST			= 0x0B90,
	GL_STENCIL_WRITEMASK		= 0x0B98,
	GL_STENCIL_BITS			= 0x0D57,
	GL_STENCIL_FUNC			= 0x0B92,
	GL_STENCIL_VALUE_MASK		= 0x0B93,
	GL_STENCIL_REF			= 0x0B97,
	GL_STENCIL_FAIL			= 0x0B94,
	GL_STENCIL_PASS_DEPTH_PASS		= 0x0B96,
	GL_STENCIL_PASS_DEPTH_FAIL		= 0x0B95,
	GL_STENCIL_CLEAR_VALUE		= 0x0B91,
	GL_STENCIL_INDEX			= 0x1901,
	GL_KEEP				= 0x1E00,
	GL_REPLACE				= 0x1E01,
	GL_INCR				= 0x1E02,
	GL_DECR				= 0x1E03,

    // Буферы, рисование/чтение пикселей
    ПУСТО                                = 0x0,
    ЛЕВЫЙ                                = 0x0406,
    ПРАВЫЙ                               = 0x0407,
    ПЕРЕДНИЙ_ЛЕВЫЙ                          = 0x0400,
    ПЕРЕДНИЙ_ПРАВЫЙ                         = 0x0401,
    ЗАДНИЙ_ЛЕВЫЙ                           = 0x0402,
    ЗАДНИЙ_ПРАВЫЙ                          = 0x0403,
    ДОП0                                = 0x0409,
    ДОП1                                = 0x040A,
    ДОП2                                = 0x040B,
    ДОП3                                = 0x040C,
    ЦВЕТОИНДЕКС                         = 0x1900,
    КРАСНЫЙ                                 = 0x1903,
    ЗЕЛЁНЫЙ                               = 0x1904,
    СИНИЙ                                = 0x1905,
    АЛЬФА                               = 0x1906,
    СВЕЧЕНИЕ                           = 0x1909,
    АЛЬФА_СВЕЧЕНИЯ                     = 0x190A,
    АЛЬФАБИТЫ                          = 0x0D55,
    КРАСНЫЕ_БИТЫ                            = 0x0D52,
    ЗЕЛЁНЫЕ_БИТЫ                          = 0x0D53,
    СИНИЕ_БИТЫ                           = 0x0D54,
    ИНДЕКСБИТЫ                          = 0x0D51,
    БИТЫ_СУБПИКСЕЛЕЙ                       = 0x0D50,
    ДОП_БУФЕРЫ                         = 0x0C00,
    БУФЕР_ЧТЕНИЯ                         = 0x0C02,
    БУФЕР_РИСОВАНИЯ                         = 0x0C01,
    ДВОЙНОЙ_БУФЕР                        = 0x0C32,
    СТЕРЕО                              = 0x0C33,
    БИТМАП                              = 0x1A00,
    ЦВЕТ                               = 0x1800,
    ДАЛЬ                               = 0x1801,
    ШАБЛОН                             = 0x1802,
    ПСЕВДО_СЛУЧАЙНЫЙ                              = 0x0BD0,
    КЗС                                 = 0x1907,
    КЗСА                                = 0x1908,
	//English
	GL_NONE				= 0x0,
	GL_LEFT				= 0x0406, 
	GL_RIGHT				= 0x0407,
	GL_FRONT_LEFT			= 0x0400,
	GL_FRONT_RIGHT			= 0x0401,
	GL_BACK_LEFT			= 0x0402,
	GL_BACK_RIGHT			= 0x0403,
	GL_AUX0				= 0x0409,
	GL_AUX1				= 0x040A,
	GL_AUX2				= 0x040B,
	GL_AUX3				= 0x040C,
	GL_COLOR_INDEX			= 0x1900,
	GL_RED				= 0x1903,
	GL_GREEN				= 0x1904,
	GL_BLUE				= 0x1905,
	GL_ALPHA				= 0x1906,
	GL_LUMINANCE			= 0x1909,
	GL_LUMINANCE_ALPHA			= 0x190A,
	GL_ALPHA_BITS			= 0x0D55,
	GL_RED_BITS			= 0x0D52,
	GL_GREEN_BITS			= 0x0D53,
	GL_BLUE_BITS			= 0x0D54,
	GL_INDEX_BITS			= 0x0D51,
	GL_SUBPIXEL_BITS			= 0x0D50,
	GL_AUX_BUFFERS			= 0x0C00,
	GL_READ_BUFFER			= 0x0C02,
	GL_DRAW_BUFFER			= 0x0C01,
	GL_DOUBLEBUFFER			= 0x0C32,
	GL_STEREO				= 0x0C33,
	GL_BITMAP				= 0x1A00,
	GL_COLOR				= 0x1800,
	GL_DEPTH				= 0x1801,
	GL_STENCIL				= 0x1802,
	GL_DITHER				= 0x0BD0,
	GL_RGB				= 0x1907,
	GL_RGBA				= 0x1908,

    // Реализационные границы
    МАКС_ВНЕДРЕНИЕ_СПИСКА                    = 0x0B31,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ              = 0x0D35,
    МАКС_ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ           = 0x0D36,
    МАКС_ГЛУБИНА_СТЕКА_ИМЁН                = 0x0D37,
    МАКС_ГЛУБИНА_СТЕКА_ПРОЕКЦИЙ          = 0x0D38,
    МАКС_ГЛУБИНА_СТЕКА_ТЕКСТУР             = 0x0D39,
    МАКС_ПОРЯДОК_ОЦЕНКИ                      = 0x0D30,
    МАКС_ОГНЕЙ                          = 0x0D31,
    МАКС_ПЛОСКОСТЕЙ_ОБРЕЗКИ                     = 0x0D32,
    МАКС_РАЗМЕР_ТЕКСТУРЫ                    = 0x0D33,
    МАКС_ТАБЛИЦА_КАРТЫ_ПИКСЕЛЕЙ                 = 0x0D34,
    МАКС_РАЗМЕРЫ_ВЬЮПОРТА                   = 0x0D3A,
    МАКС_ГЛУБИНА_СТЕКА_АТРИБУТОВ_КЛИЕНТА       = 0x0D3B,
	//English
	GL_MAX_LIST_NESTING		= 0x0B31,
	GL_MAX_ATTRIB_STACK_DEPTH		= 0x0D35,
	GL_MAX_MODELVIEW_STACK_DEPTH	= 0x0D36,
	GL_MAX_NAME_STACK_DEPTH		= 0x0D37,
	GL_MAX_PROJECTION_STACK_DEPTH	= 0x0D38,
	GL_MAX_TEXTURE_STACK_DEPTH		= 0x0D39,
	GL_MAX_EVAL_ORDER			= 0x0D30,
	GL_MAX_LIGHTS			= 0x0D31,
	GL_MAX_CLIP_PLANES			= 0x0D32,
	GL_MAX_TEXTURE_SIZE		= 0x0D33,
	GL_MAX_PIXEL_MAP_TABLE		= 0x0D34,
	GL_MAX_VIEWPORT_DIMS		= 0x0D3A,
	GL_MAX_CLIENT_ATTRIB_STACK_DEPTH	= 0x0D3B,

    // Получатели
    ГЛУБИНА_СТЕКА_АТРИБУТОВ                  = 0x0BB0,
    ГЛУБИНА_СТЕКА_АТРИБ_КЛИЕНТА           = 0x0BB1,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ЦВЕТА                   = 0x0C22,
    МАСКА_ЗАПИСИ_ЦВЕТА                     = 0x0C23,
    ТЕКУЩИЙ_ИНДЕКС                       = 0x0B01,
    ТЕКУЩИЙ_ЦВЕТ                       = 0x0B00,
    ТЕКУЩАЯ_НОРМАЛЬ                      = 0x0B02,
    ТЕКУЩИЙ_ЦВЕТ_РАСТРА                = 0x0B04,
    ТЕКУЩЕЕ_УДАЛЕНИЕ_РАСТРА             = 0x0B09,
    ТЕКУЩИЙ_ИНДЕКС_РАСТРА                = 0x0B05,
    ТЕКУЩАЯ_ПОЗИЦИЯ_РАСТРА             = 0x0B07,
    ТЕКУЩИЕ_КООРД_ТЕКСТУРЫ_РАСТРА       = 0x0B06,
    ТЕКУЩЕЕ_ПОЛОЖЕНИЕ_РАСТРА_НОРМ       = 0x0B08,
    ТЕКУЩИЕ_КООРИНАТЫ_ТЕКСТУРЫ              = 0x0B03,
    ЗНАЧЕНИЕ_ОЧИСТКИ_ИНДЕКСА                   = 0x0C20,
    РЕЖИМ_ИНДЕКСА                          = 0x0C30,
    МАСКА_ЗАПИСИ_ИНДЕКСА                     = 0x0C21,
    МАТРИЦА_ОБЗОРА_МОДЕЛИ                    = 0x0BA6,
    ГЛУБИНА_СТЕКА_ОБЗОРА_МОДЕЛИ               = 0x0BA3,
    ГЛУБИНА_СТЕКА_ИМЁН                    = 0x0D70,
    МАТРИЦА_ПРОЕКЦИИ                   = 0x0BA7,
    ГЛУБИНА_СТЕКА_ПРОЕКЦИИ              = 0x0BA4,
    РЕЖИМ_ОТОБРАЖЕНИЯ                         = 0x0C40,
    РЕЖИМ_КЗСА                           = 0x0C31,
    МАТРИЦА_ТЕКСТУРЫ                      = 0x0BA8,
    ГЛУБИНА_СТЕКА_ТЕКСТУР                 = 0x0BA5,
    ВЬЮПОРТ                            = 0x0BA2,
	//English
	GL_ATTRIB_STACK_DEPTH		= 0x0BB0,
	GL_CLIENT_ATTRIB_STACK_DEPTH	= 0x0BB1,
	GL_COLOR_CLEAR_VALUE		= 0x0C22,
	GL_COLOR_WRITEMASK			= 0x0C23,
	GL_CURRENT_INDEX			= 0x0B01,
	GL_CURRENT_COLOR			= 0x0B00,
	GL_CURRENT_NORMAL			= 0x0B02,
	GL_CURRENT_RASTER_COLOR		= 0x0B04,
	GL_CURRENT_RASTER_DISTANCE		= 0x0B09,
	GL_CURRENT_RASTER_INDEX		= 0x0B05,
	GL_CURRENT_RASTER_POSITION		= 0x0B07,
	GL_CURRENT_RASTER_TEXTURE_COORDS	= 0x0B06,
	GL_CURRENT_RASTER_POSITION_VALID	= 0x0B08,
	GL_CURRENT_TEXTURE_COORDS		= 0x0B03,
	GL_INDEX_CLEAR_VALUE		= 0x0C20,
	GL_INDEX_MODE			= 0x0C30,
	GL_INDEX_WRITEMASK			= 0x0C21,
	GL_MODELVIEW_MATRIX		= 0x0BA6,
	GL_MODELVIEW_STACK_DEPTH		= 0x0BA3,
	GL_NAME_STACK_DEPTH		= 0x0D70,
	GL_PROJECTION_MATRIX		= 0x0BA7,
	GL_PROJECTION_STACK_DEPTH		= 0x0BA4,
	GL_RENDER_MODE			= 0x0C40,
	GL_RGBA_MODE			= 0x0C31,
	GL_TEXTURE_MATRIX			= 0x0BA8,
	GL_TEXTURE_STACK_DEPTH		= 0x0BA5,
	GL_VIEWPORT			= 0x0BA2,

    // Оцениватели
    АВТО_НОРМАЛЬ                         = 0x0D80,
    КАРТА1_ЦВЕТ_4                        = 0x0D90,
    КАРТА1_ДОМЕН_СЕТКИ                    = 0x0DD0,
    КАРТА1_ОТРЕЗКИ_СЕТКИ                  = 0x0DD1,
    КАРТА1_ИНДЕКС                          = 0x0D91,
    КАРТА1_НОРМАЛЬ                         = 0x0D92,
    КАРТА1_КООРД_ТЕКСТУРЫ_1                = 0x0D93,
    КАРТА1_КООРД_ТЕКСТУРЫ_2                = 0x0D94,
    КАРТА1_КООРД_ТЕКСТУРЫ_3                = 0x0D95,
    КАРТА1_КООРД_ТЕКСТУРЫ_4                = 0x0D96,
    КАРТА1_ВЕРШИНА_3                       = 0x0D97,
    КАРТА1_ВЕРШИНА_4                       = 0x0D98,
    КАРТА2_ЦВЕТ_4                        = 0x0DB0,
    КАРТА2_ДОМЕН_СЕТКИ                    = 0x0DD2,
    КАРТА2_ОТРЕЗКИ_СЕТКИ                  = 0x0DD3,
    КАРТА2_ИНДЕКС                          = 0x0DB1,
    КАРТА2_НОРМАЛЬ                         = 0x0DB2,
    КАРТА2_КООРД_ТЕКСТУРЫ_1                = 0x0DB3,
    КАРТА2_КООРД_ТЕКСТУРЫ_2                = 0x0DB4,
    КАРТА2_КООРД_ТЕКСТУРЫ_3                = 0x0DB5,
    КАРТА2_КООРД_ТЕКСТУРЫ_4                = 0x0DB6,
    КАРТА2_ВЕРШИНА_3                       = 0x0DB7,
    КАРТА2_ВЕРШИНА_4                       = 0x0DB8,
    КОЭФФ                               = 0x0A00,
    ДОМЕН                              = 0x0A02,
    ПОРЯДОК                               = 0x0A01,
	//English
	GL_AUTO_NORMAL			= 0x0D80,
	GL_MAP1_COLOR_4			= 0x0D90,
	GL_MAP1_GRID_DOMAIN		= 0x0DD0,
	GL_MAP1_GRID_SEGMENTS		= 0x0DD1,
	GL_MAP1_INDEX			= 0x0D91,
	GL_MAP1_NORMAL			= 0x0D92,
	GL_MAP1_TEXTURE_COORD_1		= 0x0D93,
	GL_MAP1_TEXTURE_COORD_2		= 0x0D94,
	GL_MAP1_TEXTURE_COORD_3		= 0x0D95,
	GL_MAP1_TEXTURE_COORD_4		= 0x0D96,
	GL_MAP1_VERTEX_3			= 0x0D97,
	GL_MAP1_VERTEX_4			= 0x0D98,
	GL_MAP2_COLOR_4			= 0x0DB0,
	GL_MAP2_GRID_DOMAIN		= 0x0DD2,
	GL_MAP2_GRID_SEGMENTS		= 0x0DD3,
	GL_MAP2_INDEX			= 0x0DB1,
	GL_MAP2_NORMAL			= 0x0DB2,
	GL_MAP2_TEXTURE_COORD_1		= 0x0DB3,
	GL_MAP2_TEXTURE_COORD_2		= 0x0DB4,
	GL_MAP2_TEXTURE_COORD_3		= 0x0DB5,
	GL_MAP2_TEXTURE_COORD_4		= 0x0DB6,
	GL_MAP2_VERTEX_3			= 0x0DB7,
	GL_MAP2_VERTEX_4			= 0x0DB8,
	GL_COEFF				= 0x0A00,
	GL_DOMAIN				= 0x0A02,
	GL_ORDER				= 0x0A01,

    // Подсказки
    ТУМАН_ПОДСКАЗКА                            = 0x0C54,
    СМЯГЧЕНИЕ_ЛИНИИ_ПОДСКАЗКА                    = 0x0C52,
    КОРРЕКЦИЯ_ПЕРСПЕКТИВЫ_ПОДСКАЗКА         = 0x0C50,
    СМЯГЧЕНИЕ_ТОЧКИ_ПОДСКАЗКА                   = 0x0C51,
    СМЯГЧЕНИЕ_МНОГОУГ_ПОДСКАЗКА                 = 0x0C53,
    НЕ_ВАЖНО                           = 0x1100,
    НАИБЫСТРО                             = 0x1101,
    НАИЛУЧШЕ                              = 0x1102,
	//English
	GL_FOG_HINT			= 0x0C54,
	GL_LINE_SMOOTH_HINT		= 0x0C52,
	GL_PERSPECTIVE_CORRECTION_HINT	= 0x0C50,
	GL_POINT_SMOOTH_HINT		= 0x0C51,
	GL_POLYGON_SMOOTH_HINT		= 0x0C53,
	GL_DONT_CARE			= 0x1100,
	GL_FASTEST				= 0x1101,
	GL_NICEST				= 0x1102,

    // Захват ножницами
    ТЕСТ_НОЖНИЦ                        = 0x0C11,
    ЗАХВАТ_НОЖНИЦ                         = 0x0C10,
	//English
	GL_SCISSOR_TEST			= 0x0C11,
	GL_SCISSOR_BOX			= 0x0C10,

    // Пиксельный режим/перенос
    ЦВЕТ_КАРТЫ                           = 0x0D10,
    ШАБЛОН_КАРТЫ                         = 0x0D11,
    СДВИГ_ИНДЕКСА                         = 0x0D12,
    СМЕЩЕНИЕ_ИНДЕКСА                        = 0x0D13,
    ШКАЛА_КРАСНОГО                           = 0x0D14,
    УКЛОН_КРАСНОГО                            = 0x0D15,
    ШКАЛА_ЗЕЛЁНОГО                         = 0x0D18,
    УКЛОН_ЗЕЛЁНОГО                          = 0x0D19,
    ШКАЛА_СИНЕГО                          = 0x0D1A,
    УКЛОН_СИНЕГО                           = 0x0D1B,
    ШКАЛА_АЛЬФЫ                         = 0x0D1C,
    УКЛОН_АЛЬФЫ                          = 0x0D1D,
    ШКАЛА_ДАЛИ                         = 0x0D1E,
    УКЛОН_ДАЛИ                          = 0x0D1F,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Т_В_Т               = 0x0CB1,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_Ц               = 0x0CB0,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_К               = 0x0CB2,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_G               = 0x0CB3,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_С              = 0x0CB4,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_Ц_В_А              = 0x0CB5,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_К_В_К               = 0x0CB6,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_З_В_З               = 0x0CB7,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_С_В_С               = 0x0CB8,
    РАЗМЕР_КАРТЫ_ПИКСЕЛЯ_А_В_А               = 0x0CB9,
    КАРТА_ПИКСЕЛЯ_Т_В_Т                    = 0x0C71,
    КАРТА_ПИКСЕЛЯ_Ц_В_Ц                    = 0x0C70,
    КАРТА_ПИКСЕЛЯ_Ц_В_К                    = 0x0C72,
    КАРТА_ПИКСЕЛЯ_Ц_В_З                    = 0x0C73,
    КАРТА_ПИКСЕЛЯ_Ц_В_С                    = 0x0C74,
    КАРТА_ПИКСЕЛЯ_Ц_В_А                    = 0x0C75,
    КАРТА_ПИКСЕЛЯ_К_В_К                    = 0x0C76,
    КАРТА_ПИКСЕЛЯ_З_В_З                    = 0x0C77,
    КАРТА_ПИКСЕЛЯ_С_В_С                    = 0x0C78,
    КАРТА_ПИКСЕЛЯ_А_В_А                    = 0x0C79,
    ПАК_РАСКЛАДКА                      = 0x0D05,
    ПАК_ВНАЧАЛЕ_МЛБ                      = 0x0D01,
    ПАК_ДЛИНА_РЯДА                     = 0x0D02,
    ПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                    = 0x0D04,
    ПАК_ПРОПУСТИТЬ_РЯДЫ                     = 0x0D03,
    ПАК_ОБМЕНЯТЬ_БУФЕРЫ                     = 0x0D00,
    РАСПАК_РАСКЛАДКА                    = 0x0CF5,
    РАСПАК_ВНАЧАЛЕ_МЛБ                    = 0x0CF1,
    РАСПАК_ДЛИНА_РЯДА                   = 0x0CF2,
    РАСПАК_ПРОПУСТИТЬ_ПИКСЕЛИ                  = 0x0CF4,
    РАСПАК_ПРОПУСТИТЬ_РЯДЫ                    = 0x0CF3,
    РАСПАК_ОБМЕНЯТЬ_БУФЕРЫ                   = 0x0CF0,
    ЗУМ_КШ                              = 0x0D16,
    ЗУМ_КВ                              = 0x0D17,
	//English
    GL_MAP_COLOR			= 0x0D10,
	GL_MAP_STENCIL			= 0x0D11,
	GL_INDEX_ШИФТ			= 0x0D12,
	GL_INDEX_OFFSET			= 0x0D13,
	GL_RED_SCALE			= 0x0D14,
	GL_RED_BIAS			= 0x0D15,
	GL_GREEN_SCALE			= 0x0D18,
	GL_GREEN_BIAS			= 0x0D19,
	GL_BLUE_SCALE			= 0x0D1A,
	GL_BLUE_BIAS			= 0x0D1B,
	GL_ALPHA_SCALE			= 0x0D1C,
	GL_ALPHA_BIAS			= 0x0D1D,
	GL_DEPTH_SCALE			= 0x0D1E,
	GL_DEPTH_BIAS			= 0x0D1F,
	GL_PIXEL_MAP_S_TO_S_SIZE		= 0x0CB1,
	GL_PIXEL_MAP_I_TO_I_SIZE		= 0x0CB0,
	GL_PIXEL_MAP_I_TO_R_SIZE		= 0x0CB2,
	GL_PIXEL_MAP_I_TO_G_SIZE		= 0x0CB3,
	GL_PIXEL_MAP_I_TO_B_SIZE		= 0x0CB4,
	GL_PIXEL_MAP_I_TO_A_SIZE		= 0x0CB5,
	GL_PIXEL_MAP_R_TO_R_SIZE		= 0x0CB6,
	GL_PIXEL_MAP_G_TO_G_SIZE		= 0x0CB7,
	GL_PIXEL_MAP_B_TO_B_SIZE		= 0x0CB8,
	GL_PIXEL_MAP_A_TO_A_SIZE		= 0x0CB9,
	GL_PIXEL_MAP_S_TO_S		= 0x0C71,
	GL_PIXEL_MAP_I_TO_I		= 0x0C70,
	GL_PIXEL_MAP_I_TO_R		= 0x0C72,
	GL_PIXEL_MAP_I_TO_G		= 0x0C73,
	GL_PIXEL_MAP_I_TO_B		= 0x0C74,
	GL_PIXEL_MAP_I_TO_A		= 0x0C75,
	GL_PIXEL_MAP_R_TO_R		= 0x0C76,
	GL_PIXEL_MAP_G_TO_G		= 0x0C77,
	GL_PIXEL_MAP_B_TO_B		= 0x0C78,
	GL_PIXEL_MAP_A_TO_A		= 0x0C79,
	GL_PACK_ALIGNMENT			= 0x0D05,
	GL_PACK_LSB_FIRST			= 0x0D01,
	GL_PACK_ROW_LENGTH			= 0x0D02,
	GL_PACK_SKIP_PIXELS		= 0x0D04,
	GL_PACK_SKIP_ROWS			= 0x0D03,
	GL_PACK_SWAP_BYTES			= 0x0D00,
	GL_UNPACK_ALIGNMENT		= 0x0CF5,
	GL_UNPACK_LSB_FIRST		= 0x0CF1,
	GL_UNPACK_ROW_LENGTH		= 0x0CF2,
	GL_UNPACK_SKIP_PIXELS		= 0x0CF4,
	GL_UNPACK_SKIP_ROWS		= 0x0CF3,
	GL_UNPACK_SWAP_BYTES		= 0x0CF0,
	GL_ZOOM_X				= 0x0D16,
	GL_ZOOM_Y				= 0x0D17,

    // Картирование текстуры
    СРЕДА_ТЕКС                         = 0x2300,
    РЕЖИМ_СРЕДЫ_ТЕКС                    = 0x2200,
    ТЕКСТУРА_М1                          = 0x0DE0,
    ТЕКСТУРА_М2                          = 0x0DE1,
    TEXTURE_WRAP_S                      = 0x2802,
    TEXTURE_WRAP_T                      = 0x2803,
    TEXTURE_MAG_FILTER                  = 0x2800,
    TEXTURE_MIN_FILTER                  = 0x2801,
    СРЕДА_ТЕКС_ЦВЕТ                   = 0x2201,
    ГЕН_ТЕКС_S                       = 0x0C60,
    ГЕН_ТЕКС_T                       = 0x0C61,
    РЕЖИМ_ГЕН_ТЕКСТУРЫ                    = 0x2500,
    ЦВЕТ_КАЙМЫ_ТЕКСТУРЫ                = 0x1004,
    ШИРИНА_ТЕКСТУРЫ                       = 0x1000,
    ВЫСОТА_ТЕКСТУРЫ                      = 0x1001,
    КАЙМА_ТЕКСТУРЫ                      = 0x1005,
    КОМПОНЕНТЫ_ТЕКСТУРЫ                  = 0x1003,
    РАЗМЕР_КРАСНОГО_ТЕКСТУРЫ                    = 0x805C,
    РАЗМЕР_ЗЕЛЁНОГО_ТЕКСТУРЫ                  = 0x805D,
    РАЗМЕР_СИНЕГО_ТЕКСТУРЫ                   = 0x805E,
    РАЗМЕР_АЛЬФЫ_ТЕКСТУРЫ                  = 0x805F,
    РАЗМЕР_ОСВЕЩЕННОСТИ_ТЕКСТУРЫ              = 0x8060,
    РАЗМЕР_ИНТЕНСИВНОСТИ_ТЕКСТУРЫ              = 0x8061,
	 NEAREST_MIPКАРТА_NEAREST              = 0x2700,
    NEAREST_MIPКАРТА_LINEAR               = 0x2702,
    LINEAR_MIPКАРТА_NEAREST               = 0x2701,
    LINEAR_MIPКАРТА_LINEAR                = 0x2703,
    ЛИНЕЙНЫЙ_ОБЪЕКТ                       = 0x2401,
    ПЛОСКИЙ_ОБЪЕКТ                        = 0x2501,
    EYE_LINEAR                          = 0x2400,
    EYE_PLANE                           = 0x2502,
    КАРТА_ШАРА                          = 0x2402,
    DECAL                               = 0x2101,
    МОДУЛИРУЙ                            = 0x2100,
    БЛИЖАЙШАЯ                             = 0x2600,
    ПОВТОРИ                              = 0x2901,
    CLAMP                               = 0x2900,
    S                                   = 0x2000,
    T                                   = 0x2001,
    R                                   = 0x2002,
    Q                                   = 0x2003,
    ГЕН_ТЕКС_R                       = 0x0C62,
    ГЕН_ТЕКС_Q                       = 0x0C63,
	//English
	GL_TEXTURE_ENV			= 0x2300,
	GL_TEXTURE_ENV_MODE		= 0x2200,
	GL_TEXTURE_1D			= 0x0DE0,
	GL_TEXTURE_2D			= 0x0DE1,
	GL_TEXTURE_WRAP_S			= 0x2802,
	GL_TEXTURE_WRAP_T			= 0x2803,
	GL_TEXTURE_MAG_FILTER		= 0x2800,
	GL_TEXTURE_MIN_FILTER		= 0x2801,
	GL_TEXTURE_ENV_COLOR		= 0x2201,
	GL_TEXTURE_GEN_S			= 0x0C60,
	GL_TEXTURE_GEN_T			= 0x0C61,
	GL_TEXTURE_GEN_MODE		= 0x2500,
	GL_TEXTURE_BORDER_COLOR		= 0x1004,
	GL_TEXTURE_WIDTH			= 0x1000,
	GL_TEXTURE_HEIGHT			= 0x1001,
	GL_TEXTURE_BORDER			= 0x1005,
	GL_TEXTURE_COMPONENTS		= 0x1003,
	GL_TEXTURE_RED_SIZE		= 0x805C,
	GL_TEXTURE_GREEN_SIZE		= 0x805D,
	GL_TEXTURE_BLUE_SIZE		= 0x805E,
	GL_TEXTURE_ALPHA_SIZE		= 0x805F,
	GL_TEXTURE_LUMINANCE_SIZE		= 0x8060,
	GL_TEXTURE_INTENSITY_SIZE		= 0x8061,
	GL_NEAREST_MIPMAP_NEAREST		= 0x2700,
	GL_NEAREST_MIPMAP_LINEAR		= 0x2702,
	GL_LINEAR_MIPMAP_NEAREST		= 0x2701,
	GL_LINEAR_MIPMAP_LINEAR		= 0x2703,
	GL_OBJECT_LINEAR			= 0x2401,
	GL_OBJECT_PLANE			= 0x2501,
	GL_EYE_LINEAR			= 0x2400,
	GL_EYE_PLANE			= 0x2502,
	GL_SPHERE_MAP			= 0x2402,
	GL_DECAL				= 0x2101,
	GL_MODULATE			= 0x2100,
	GL_NEAREST				= 0x2600,
	GL_REPEAT				= 0x2901,
	GL_CLAMP				= 0x2900,
	GL_S				= 0x2000,
	GL_T				= 0x2001,
	GL_R				= 0x2002,
	GL_Q				= 0x2003,
	GL_TEXTURE_GEN_R			= 0x0C62,
	GL_TEXTURE_GEN_Q			= 0x0C63,

    // Утилиты
    ПРОИЗВОДИТЕЛЬ                              = 0x1F00,
    ОТОБРАЗИТЕЛЬ                            = 0x1F01,
    ВЕРСИЯ                             = 0x1F02,
    РАСШИРЕНИЯ                          = 0x1F03,
	//English
	GL_VENDOR				= 0x1F00,
	GL_RENDERER			= 0x1F01,
	GL_VERSION				= 0x1F02,
	GL_EXTENSIONS			= 0x1F03,

    // Ошибки
    ОШИБОК_НЕТ                            = 0x0,
    НЕВЕРНОЕ_ЗНАЧЕНИЕ                       = 0x0501,
    НЕПРАВИЛЬНЫЙ_ПЕРЕЧЕНЬ                        = 0x0500,
    НЕВЕРНАЯ_ОПЕРАЦИЯ                   = 0x0502,
    ПЕРЕПОЛНЕНИЕ_СТЕКА                      = 0x0503,
    НЕДОБОР_СТЕКА                    = 0x0504,
    НЕХВАТКА_ПАМЯТИ                       = 0x0505,
	//English
	GL_NO_ERROR			= 0x0,
	GL_INVALID_VALUE			= 0x0501,
	GL_INVALID_ENUM			= 0x0500,
	GL_INVALID_OPERATION		= 0x0502,
	GL_STACK_OVERFLOW			= 0x0503,
	GL_STACK_UNDERFLOW			= 0x0504,
	GL_OUT_OF_MEMORY			= 0x0505,
}

// glPush/PopAttrib bits
enum : бцел
{
    ТЕКУЩИЙ_БИТ                         = 0x00000001,
    БИТ_ТОЧКИ                           = 0x00000002,
    БИТ_ЛИНИИ                            = 0x00000004,
    БИТ_МНОГОУГ                         = 0x00000008,
    БИТ_УЗОРА_МНОГОУГ                 = 0x00000010,
    БИТ__РЕЖИМА_ПИКСЕЛЯ                      = 0x00000020,
    БИТ_ОСВЕЩЕНИЯ                        = 0x00000040,
    БИТ_ТУМАНА                             = 0x00000080,
    БИТ_БУФЕРА_ДАЛИ                    = 0x00000100,
    БИТ_БУФЕРА_АККУМ                    = 0x00000200,
    БИТ_БУФЕРА_ШАБЛОНА                  = 0x00000400,
    БИТ_ВЬЮПОРТА                        = 0x00000800,
    БИТ_ТРАНСФОРМА                       = 0x00001000,
    БИТ_ВКЛЮЧИТЬ                          = 0x00002000,
    БИТ_БУФЕРА_ЦВЕТА                    = 0x00004000,
    БИТ_ПОДСКАЗКИ                            = 0x00008000,
    БИТ_ОЦЕНКИ                            = 0x00010000,
    БИТ_СПИСКА                            = 0x00020000,
    БИТ_ТЕКСТУРЫ                         = 0x00040000,
    БИТ_НОЖНИЦ                         = 0x00080000,
    БИТЫ_ВСЕХ_АТРИБУТОВ                     = 0x000FFFFF,
	//English
	GL_CURRENT_BIT			= 0x00000001,
	GL_POINT_BIT			= 0x00000002,
	GL_LINE_BIT			= 0x00000004,
	GL_POLYGON_BIT			= 0x00000008,
	GL_POLYGON_STIPPLE_BIT		= 0x00000010,
	GL_PIXEL_MODE_BIT			= 0x00000020,
	GL_LIGHTING_BIT			= 0x00000040,
	GL_FOG_BIT				= 0x00000080,
	GL_DEPTH_BUFFER_BIT		= 0x00000100,
	GL_ACCUM_BUFFER_BIT		= 0x00000200,
	GL_STENCIL_BUFFER_BIT		= 0x00000400,
	GL_VIEWPORT_BIT			= 0x00000800,
	GL_TRANSFORM_BIT			= 0x00001000,
	GL_ENABLE_BIT			= 0x00002000,
	GL_COLOR_BUFFER_BIT		= 0x00004000,
	GL_HINT_BIT			= 0x00008000,
	GL_EVAL_BIT			= 0x00010000,
	GL_LIST_BIT			= 0x00020000,
	GL_TEXTURE_BIT			= 0x00040000,
	GL_SCISSOR_BIT			= 0x00080000,
	GL_ALL_ATTRIB_BITS			= 0x000FFFFF,
	}

// gl 1.1
enum : Гперечень
{
ПРОКСИТЕКСТУРА_1М                    = 0x8063,
ПРОКСИТЕКСТУРА_2М                    = 0x8064,
ПРИОРИТЕТ_ТЕКСТУРЫ                    = 0x8066,
РЕЗИДЕНТНАЯ_ТЕКСТУРА                    = 0x8067,
ПРИВЯЗКА_ТЕКСТУРЫ_1М                  = 0x8068,
ПРИВЯЗКА_ТЕКСТУРЫ_2М                  = 0x8069,
ВНУТРЕННИЙ_ФОРМАТ_ТЕКСТУРЫ             = 0x1003,
АЛЬФА4                              = 0x803B,
АЛЬФА8                              = 0x803C,
АЛЬФА12                             = 0x803D,
АЛЬФА16                             = 0x803E,
СВЕТИМОСТЬ4                          = 0x803F,
СВЕТИМОСТЬ8                          = 0x8040,
СВЕТИМОСТЬ12                         = 0x8041,
СВЕТИМОСТЬ16                         = 0x8042,
СВЕТИМОСТЬ4_АЛЬФА4                   = 0x8043,
СВЕТИМОСТЬ6_АЛЬФА2                   = 0x8044,
СВЕТИМОСТЬ8_АЛЬФА8                   = 0x8045,
СВЕТИМОСТЬ12_АЛЬФА4                  = 0x8046,
СВЕТИМОСТЬ12_АЛЬФА12                 = 0x8047,
СВЕТИМОСТЬ16_АЛЬФА16                 = 0x8048,
ИНТЕНСИВНОСТЬ                           = 0x8049,
ИНТЕНСИВНОСТЬ4                          = 0x804A,
ИНТЕНСИВНОСТЬ8                          = 0x804B,
ИНТЕНСИВНОСТЬ12                         = 0x804C,
ИНТЕНСИВНОСТЬ16                         = 0x804D,
К3_З3_С2                            = 0x2A10,
КЗС4                                = 0x804F,
КЗС5                                = 0x8050,
КЗС8                                = 0x8051,
КЗС10                               = 0x8052,
КЗС12                               = 0x8053,
КЗС16                               = 0x8054,
КЗСА2                               = 0x8055,
КЗСА4                               = 0x8056,
КЗС5_А1                             = 0x8057,
КЗСА8                               = 0x8058,
КЗС10_А2                            = 0x8059,
КЗСА12                              = 0x805A,
КЗСА16                              = 0x805B,
//English
GL_PROXY_TEXTURE_1D		= 0x8063,
GL_PROXY_TEXTURE_2D		= 0x8064,
GL_TEXTURE_PRIORITY		= 0x8066,
GL_TEXTURE_RESIDENT		= 0x8067,
GL_TEXTURE_BINDING_1D		= 0x8068,
GL_TEXTURE_BINDING_2D		= 0x8069,
GL_TEXTURE_INTERNAL_FORMAT		= 0x1003,
GL_ALPHA4				= 0x803B,
GL_ALPHA8				= 0x803C,
GL_ALPHA12				= 0x803D,
GL_ALPHA16				= 0x803E,
GL_LUMINANCE4			= 0x803F,
GL_LUMINANCE8			= 0x8040,
GL_LUMINANCE12			= 0x8041,
GL_LUMINANCE16			= 0x8042,
GL_LUMINANCE4_ALPHA4		= 0x8043,
GL_LUMINANCE6_ALPHA2		= 0x8044,
GL_LUMINANCE8_ALPHA8		= 0x8045,
GL_LUMINANCE12_ALPHA4		= 0x8046,
GL_LUMINANCE12_ALPHA12		= 0x8047,
GL_LUMINANCE16_ALPHA16		= 0x8048,
GL_INTENSITY			= 0x8049,
GL_INTENSITY4			= 0x804A,
GL_INTENSITY8			= 0x804B,
GL_INTENSITY12			= 0x804C,
GL_INTENSITY16			= 0x804D,
GL_R3_G3_B2			= 0x2A10,
GL_RGB4				= 0x804F,
GL_RGB5				= 0x8050,
GL_RGB8				= 0x8051,
GL_RGB10				= 0x8052,
GL_RGB12				= 0x8053,
GL_RGB16				= 0x8054,
GL_RGBA2				= 0x8055,
GL_RGBA4				= 0x8056,
GL_RGB5_A1				= 0x8057,
GL_RGBA8				= 0x8058,
GL_RGB10_A2			= 0x8059,
GL_RGBA12				= 0x805A,
GL_RGBA16				= 0x805B,
}

enum : бцел
{
    БИТ_ХРАНЕНИЯ_ПИКСЕЛЯ_КЛИЕНТА              = 0x00000001,
    БИТ_МАССИВА_КВЕРШИН_КЛИЕНТА             = 0x00000002,
    ВСЕ_БИТЫ_АТРБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
    БИТЫ_ВСЕХ_АТРИБУТОВ_КЛИЕНТА              = 0xFFFFFFFF,
	//English
	GL_CLIENT_PIXEL_STORE_BIT		= 0x00000001,
    GL_CLIENT_VERTEX_ARRAY_BIT		= 0x00000002,
	GL_ALL_CLIENT_ATTRIB_BITS		= 0xFFFFFFFF,
	GL_CLIENT_ALL_ATTRIB_BITS		= 0xFFFFFFFF,
}

enum: Гперечень
{
// OpenGL 1.2
 GL_RESCALE_NORMAL			= 0x803A,
 GL_CLAMP_TO_EDGE			= 0x812F,
 GL_MAX_ELEMENTS_VERTICES		= 0x80E8,
 GL_MAX_ELEMENTS_INDICES		= 0x80E9,
 GL_BGR				= 0x80E0,
 GL_BGRA				= 0x80E1,
 GL_UNSIGNED_BYTE_3_3_2		= 0x8032,
 GL_UNSIGNED_BYTE_2_3_3_REV		= 0x8362,
 GL_UNSIGNED_SHORT_5_6_5		= 0x8363,
 GL_UNSIGNED_SHORT_5_6_5_REV	= 0x8364,
 GL_UNSIGNED_SHORT_4_4_4_4		= 0x8033,
 GL_UNSIGNED_SHORT_4_4_4_4_REV	= 0x8365,
 GL_UNSIGNED_SHORT_5_5_5_1		= 0x8034,
 GL_UNSIGNED_SHORT_1_5_5_5_REV	= 0x8366,
 GL_UNSIGNED_INT_8_8_8_8		= 0x8035,
 GL_UNSIGNED_INT_8_8_8_8_REV	= 0x8367,
 GL_UNSIGNED_INT_10_10_10_2		= 0x8036,
 GL_UNSIGNED_INT_2_10_10_10_REV	= 0x8368,
 GL_LIGHT_MODEL_COLOR_CONTROL	= 0x81F8,
 GL_SINGLE_COLOR			= 0x81F9,
 GL_SEPARATE_SPECULAR_COLOR		= 0x81FA,
 GL_TEXTURE_MIN_LOD			= 0x813A,
 GL_TEXTURE_MAX_LOD			= 0x813B,
 GL_TEXTURE_BASE_LEVEL		= 0x813C,
 GL_TEXTURE_MAX_LEVEL		= 0x813D,
 GL_SMOOTH_POINT_SIZE_RANGE		= 0x0B12,
 GL_SMOOTH_POINT_SIZE_GRANULARITY	= 0x0B13,
 GL_SMOOTH_LINE_WIDTH_RANGE		= 0x0B22,
 GL_SMOOTH_LINE_WIDTH_GRANULARITY	= 0x0B23,
 GL_ALIASED_POINT_SIZE_RANGE	= 0x846D,
 GL_ALIASED_LINE_WIDTH_RANGE	= 0x846E,
 GL_PACK_SKIP_IMAGES		= 0x806B,
 GL_PACK_IMAGE_HEIGHT		= 0x806C,
 GL_UNPACK_SKIP_IMAGES		= 0x806D,
 GL_UNPACK_IMAGE_HEIGHT		= 0x806E,
 GL_TEXTURE_3D			= 0x806F,
 GL_PROXY_TEXTURE_3D		= 0x8070,
 GL_TEXTURE_DEPTH			= 0x8071,
 GL_TEXTURE_WRAP_R			= 0x8072,
 GL_MAX_3D_TEXTURE_SIZE		= 0x8073,
 GL_TEXTURE_BINDING_3D		= 0x806A,

// OpenGL 1.3
 GL_TEXTURE0			= 0x84C0,
 GL_TEXTURE1			= 0x84C1,
 GL_TEXTURE2			= 0x84C2,
 GL_TEXTURE3			= 0x84C3,
 GL_TEXTURE4			= 0x84C4,
 GL_TEXTURE5			= 0x84C5,
 GL_TEXTURE6			= 0x84C6,
 GL_TEXTURE7			= 0x84C7,
 GL_TEXTURE8			= 0x84C8,
 GL_TEXTURE9			= 0x84C9,
 GL_TEXTURE10			= 0x84CA,
 GL_TEXTURE11			= 0x84CB,
 GL_TEXTURE12			= 0x84CC,
 GL_TEXTURE13			= 0x84CD,
 GL_TEXTURE14			= 0x84CE,
 GL_TEXTURE15			= 0x84CF,
 GL_TEXTURE16			= 0x84D0,
 GL_TEXTURE17			= 0x84D1,
 GL_TEXTURE18			= 0x84D2,
 GL_TEXTURE19			= 0x84D3,
 GL_TEXTURE20			= 0x84D4,
 GL_TEXTURE21			= 0x84D5,
 GL_TEXTURE22			= 0x84D6,
 GL_TEXTURE23			= 0x84D7,
 GL_TEXTURE24			= 0x84D8,
 GL_TEXTURE25			= 0x84D9,
 GL_TEXTURE26			= 0x84DA,
 GL_TEXTURE27			= 0x84DB,
 GL_TEXTURE28			= 0x84DC,
 GL_TEXTURE29			= 0x84DD,
 GL_TEXTURE30			= 0x84DE,
 GL_TEXTURE31			= 0x84DF,
 GL_ACTIVE_TEXTURE			= 0x84E0,
 GL_CLIENT_ACTIVE_TEXTURE		= 0x84E1,
 GL_MAX_TEXTURE_UNITS		= 0x84E2,
 GL_NORMAL_MAP			= 0x8511,
 GL_REFLECTION_MAP			= 0x8512,
 GL_TEXTURE_CUBE_MAP		= 0x8513,
 GL_TEXTURE_BINDING_CUBE_MAP	= 0x8514,
 GL_TEXTURE_CUBE_MAP_POSITIVE_X	= 0x8515,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_X	= 0x8516,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Y	= 0x8517,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Y	= 0x8518,
 GL_TEXTURE_CUBE_MAP_POSITIVE_Z	= 0x8519,
 GL_TEXTURE_CUBE_MAP_NEGATIVE_Z	= 0x851A,
 GL_PROXY_TEXTURE_CUBE_MAP		= 0x851B,
 GL_MAX_CUBE_MAP_TEXTURE_SIZE	= 0x851C,
 GL_COMPRESSED_ALPHA		= 0x84E9,
 GL_COMPRESSED_LUMINANCE		= 0x84EA,
 GL_COMPRESSED_LUMINANCE_ALPHA	= 0x84EB,
 GL_COMPRESSED_INTENSITY		= 0x84EC,
 GL_COMPRESSED_RGB			= 0x84ED,
 GL_COMPRESSED_RGBA			= 0x84EE,
 GL_TEXTURE_COMPRESSION_HINT	= 0x84EF,
 GL_TEXTURE_COMPRESSED_IMAGE_SIZE	= 0x86A0,
 GL_TEXTURE_COMPRESSED		= 0x86A1,
 GL_NUM_COMPRESSED_TEXTURE_FORMATS	= 0x86A2,
 GL_COMPRESSED_TEXTURE_FORMATS	= 0x86A3,
 GL_MULTISAMPLE			= 0x809D,
 GL_SAMPLE_ALPHA_TO_COVERAGE	= 0x809E,
 GL_SAMPLE_ALPHA_TO_ONE		= 0x809F,
 GL_SAMPLE_COVERAGE			= 0x80A0,
 GL_SAMPLE_BUFFERS			= 0x80A8,
 GL_SAMPLES				= 0x80A9,
 GL_SAMPLE_COVERAGE_VALUE		= 0x80AA,
 GL_SAMPLE_COVERAGE_INVERT		= 0x80AB,
 GL_MULTISAMPLE_BIT			= 0x20000000,
 GL_TRANSPOSE_MODELVIEW_MATRIX	= 0x84E3,
 GL_TRANSPOSE_PROJECTION_MATRIX	= 0x84E4,
 GL_TRANSPOSE_TEXTURE_MATRIX	= 0x84E5,
 GL_TRANSPOSE_COLOR_MATRIX		= 0x84E6,
 GL_COMBINE				= 0x8570,
 GL_COMBINE_RGB			= 0x8571,
 GL_COMBINE_ALPHA			= 0x8572,
 GL_SOURCE0_RGB			= 0x8580,
 GL_SOURCE1_RGB			= 0x8581,
 GL_SOURCE2_RGB			= 0x8582,
 GL_SOURCE0_ALPHA			= 0x8588,
 GL_SOURCE1_ALPHA			= 0x8589,
 GL_SOURCE2_ALPHA			= 0x858A,
 GL_OPERAND0_RGB			= 0x8590,
 GL_OPERAND1_RGB			= 0x8591,
 GL_OPERAND2_RGB			= 0x8592,
 GL_OPERAND0_ALPHA			= 0x8598,
 GL_OPERAND1_ALPHA			= 0x8599,
 GL_OPERAND2_ALPHA			= 0x859A,
 GL_RGB_SCALE			= 0x8573,
 GL_ADD_SIGNED			= 0x8574,
 GL_INTERPOLATE			= 0x8575,
 GL_SUBTRACT			= 0x84E7,
 GL_CONSTANT			= 0x8576,
 GL_PRIMARY_COLOR			= 0x8577,
 GL_PREVIOUS			= 0x8578,
 GL_DOT3_RGB			= 0x86AE,
 GL_DOT3_RGBA			= 0x86AF,
 GL_CLAMP_TO_BORDER			= 0x812D,

// OpenGL 1.4
 GL_BLEND_DST_RGB			= 0x80C8,
 GL_BLEND_SRC_RGB			= 0x80C9,
 GL_BLEND_DST_ALPHA			= 0x80CA,
 GL_BLEND_SRC_ALPHA			= 0x80CB,
 GL_POINT_SIZE_MIN			= 0x8126,
 GL_POINT_SIZE_MAX			= 0x8127,
 GL_POINT_FADE_THRESHOLD_SIZE	= 0x8128,
 GL_POINT_DISTANCE_ATTENUATION	= 0x8129,
 GL_GENERATE_MIPMAP			= 0x8191,
 GL_GENERATE_MIPMAP_HINT		= 0x8192,
 GL_DEPTH_COMPONENT16		= 0x81A5,
 GL_DEPTH_COMPONENT24		= 0x81A6,
 GL_DEPTH_COMPONENT32		= 0x81A7,
 GL_MIRRORED_REPEAT			= 0x8370,
 GL_FOG_COORDINATE_SOURCE		= 0x8450,
 GL_FOG_COORDINATE			= 0x8451,
 GL_FRAGMENT_DEPTH			= 0x8452,
 GL_CURRENT_FOG_COORDINATE		= 0x8453,
 GL_FOG_COORDINATE_ARRAY_TYPE	= 0x8454,
 GL_FOG_COORDINATE_ARRAY_STRIDE	= 0x8455,
 GL_FOG_COORDINATE_ARRAY_POINTER	= 0x8456,
 GL_FOG_COORDINATE_ARRAY		= 0x8457,
 GL_COLOR_SUM			= 0x8458,
 GL_CURRENT_SECONDARY_COLOR		= 0x8459,
 GL_SECONDARY_COLOR_ARRAY_SIZE	= 0x845A,
 GL_SECONDARY_COLOR_ARRAY_TYPE	= 0x845B,
 GL_SECONDARY_COLOR_ARRAY_STRIDE	= 0x845C,
 GL_SECONDARY_COLOR_ARRAY_POINTER	= 0x845D,
 GL_SECONDARY_COLOR_ARRAY		= 0x845E,
 GL_MAX_TEXTURE_LOD_BIAS		= 0x84FD,
 GL_TEXTURE_FILTER_CONTROL		= 0x8500,
 GL_TEXTURE_LOD_BIAS		= 0x8501,
 GL_INCR_WRAP			= 0x8507,
 GL_DECR_WRAP			= 0x8508,
 GL_TEXTURE_DEPTH_SIZE		= 0x884A,
 GL_DEPTH_TEXTURE_MODE		= 0x884B,
 GL_TEXTURE_COMPARE_MODE		= 0x884C,
 GL_TEXTURE_COMPARE_FUNC		= 0x884D,
 GL_COMPARE_R_TO_TEXTURE		= 0x884E,

// OpenGL 1.5
 GL_BUFFER_SIZE			= 0x8764,
 GL_BUFFER_USAGE			= 0x8765,
 GL_QUERY_COUNTER_BITS		= 0x8864,
 GL_CURRENT_QUERY			= 0x8865,
 GL_QUERY_RESULT			= 0x8866,
 GL_QUERY_RESULT_AVAILABLE		= 0x8867,
 GL_ARRAY_BUFFER			= 0x8892,
 GL_ELEMENT_ARRAY_BUFFER		= 0x8893,
 GL_ARRAY_BUFFER_BINDING		= 0x8894,
 GL_ELEMENT_ARRAY_BUFFER_BINDING	= 0x8895,
 GL_VERTEX_ARRAY_BUFFER_BINDING	= 0x8896,
 GL_NORMAL_ARRAY_BUFFER_BINDING	= 0x8897,
 GL_COLOR_ARRAY_BUFFER_BINDING	= 0x8898,
 GL_INDEX_ARRAY_BUFFER_BINDING	= 0x8899,
 GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING= 0x889A,
 GL_EDGE_FLAG_ARRAY_BUFFER_BINDING	= 0x889B,
 GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING= 0x889C,
 GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING= 0x889D,
 GL_WEIGHT_ARRAY_BUFFER_BINDING	= 0x889E,
 GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= 0x889F,
 GL_READ_ONLY			= 0x88B8,
 GL_WRITE_ONLY			= 0x88B9,
 GL_READ_WRITE			= 0x88BA,
 GL_BUFFER_ACCESS			= 0x88BB,
 GL_BUFFER_MAPPED			= 0x88BC,
 GL_BUFFER_MAP_POINTER		= 0x88BD,
 GL_STREAM_DRAW			= 0x88E0,
 GL_STREAM_READ			= 0x88E1,
 GL_STREAM_COPY			= 0x88E2,
 GL_STATIC_DRAW			= 0x88E4,
 GL_STATIC_READ			= 0x88E5,
 GL_STATIC_COPY			= 0x88E6,
 GL_DYNAMIC_DRAW			= 0x88E8,
 GL_DYNAMIC_READ			= 0x88E9,
 GL_DYNAMIC_COPY			= 0x88EA,
 GL_SAMPLES_PASSED			= 0x8914,
 GL_FOG_COORD_SRC			= GL_FOG_COORDINATE_SOURCE,
 GL_FOG_COORD			= GL_FOG_COORDINATE,
 GL_CURRENT_FOG_COORD		= GL_CURRENT_FOG_COORDINATE,
 GL_FOG_COORD_ARRAY_TYPE		= GL_FOG_COORDINATE_ARRAY_TYPE,
 GL_FOG_COORD_ARRAY_STRIDE		= GL_FOG_COORDINATE_ARRAY_STRIDE,
 GL_FOG_COORD_ARRAY_POINTER		= GL_FOG_COORDINATE_ARRAY_POINTER,
 GL_FOG_COORD_ARRAY			= GL_FOG_COORDINATE_ARRAY,
 GL_FOG_COORD_ARRAY_BUFFER_BINDING	= GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING,
 GL_SRC0_RGB			= GL_SOURCE0_RGB,
 GL_SRC1_RGB			= GL_SOURCE1_RGB,
 GL_SRC2_RGB			= GL_SOURCE2_RGB,
 GL_SRC0_ALPHA			= GL_SOURCE0_ALPHA,
 GL_SRC1_ALPHA			= GL_SOURCE1_ALPHA,
 GL_SRC2_ALPHA			= GL_SOURCE2_ALPHA,

// OpenGL 2.0
 GL_BLEND_EQUATION_RGB		= 0x8009,
 GL_VERTEX_ATTRIB_ARRAY_ENABLED	= 0x8622,
 GL_VERTEX_ATTRIB_ARRAY_SIZE	= 0x8623,
 GL_VERTEX_ATTRIB_ARRAY_STRIDE	= 0x8624,
 GL_VERTEX_ATTRIB_ARRAY_TYPE	= 0x8625,
 GL_CURRENT_VERTEX_ATTRIB		= 0x8626,
 GL_VERTEX_PROGRAM_POINT_SIZE	= 0x8642,
 GL_VERTEX_PROGRAM_TWO_SIDE		= 0x8643,
 GL_VERTEX_ATTRIB_ARRAY_POINTER	= 0x8645,
 GL_STENCIL_BACK_FUNC		= 0x8800,
 GL_STENCIL_BACK_FAIL		= 0x8801,
 GL_STENCIL_BACK_PASS_DEPTH_FAIL	= 0x8802,
 GL_STENCIL_BACK_PASS_DEPTH_PASS	= 0x8803,
 GL_MAX_DRAW_BUFFERS		= 0x8824,
 GL_DRAW_BUFFER0			= 0x8825,
 GL_DRAW_BUFFER1			= 0x8826,
 GL_DRAW_BUFFER2			= 0x8827,
 GL_DRAW_BUFFER3			= 0x8828,
 GL_DRAW_BUFFER4			= 0x8829,
 GL_DRAW_BUFFER5			= 0x882A,
 GL_DRAW_BUFFER6			= 0x882B,
 GL_DRAW_BUFFER7			= 0x882C,
 GL_DRAW_BUFFER8			= 0x882D,
 GL_DRAW_BUFFER9			= 0x882E,
 GL_DRAW_BUFFER10			= 0x882F,
 GL_DRAW_BUFFER11			= 0x8830,
 GL_DRAW_BUFFER12			= 0x8831,
 GL_DRAW_BUFFER13			= 0x8832,
 GL_DRAW_BUFFER14			= 0x8833,
 GL_DRAW_BUFFER15			= 0x8834,
 GL_BLEND_EQUATION_ALPHA		= 0x883D,
 GL_POINT_SPRITE			= 0x8861,
 GL_COORD_REPLACE			= 0x8862,
 GL_MAX_VERTEX_ATTRIBS		= 0x8869,
 GL_VERTEX_ATTRIB_ARRAY_NORMALIZED	= 0x886A,
 GL_MAX_TEXTURE_COORDS		= 0x8871,
 GL_MAX_TEXTURE_IMAGE_UNITS		= 0x8872,
 GL_FRAGMENT_SHADER			= 0x8B30,
 GL_VERTEX_SHADER			= 0x8B31,
 GL_MAX_FRAGMENT_UNIFORM_COMPONENTS	= 0x8B49,
 GL_MAX_VERTEX_UNIFORM_COMPONENTS	= 0x8B4A,
 GL_MAX_VARYING_FLOATS		= 0x8B4B,
 GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS	= 0x8B4C,
 GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D,
 GL_SHADER_TYPE			= 0x8B4F,
 GL_FLOAT_VEC2			= 0x8B50,
 GL_FLOAT_VEC3			= 0x8B51,
 GL_FLOAT_VEC4			= 0x8B52,
 GL_INT_VEC2			= 0x8B53,
 GL_INT_VEC3			= 0x8B54,
 GL_INT_VEC4			= 0x8B55,
 GL_BOOL				= 0x8B56,
 GL_BOOL_VEC2			= 0x8B57,
 GL_BOOL_VEC3			= 0x8B58,
 GL_BOOL_VEC4			= 0x8B59,
 GL_FLOAT_MAT2			= 0x8B5A,
 GL_FLOAT_MAT3			= 0x8B5B,
 GL_FLOAT_MAT4			= 0x8B5C,
 GL_SAMPLER_1D			= 0x8B5D,
 GL_SAMPLER_2D			= 0x8B5E,
 GL_SAMPLER_3D			= 0x8B5F,
 GL_SAMPLER_CUBE			= 0x8B60,
 GL_SAMPLER_1D_SHADOW		= 0x8B61,
 GL_SAMPLER_2D_SHADOW		= 0x8B62,
 GL_DELETE_STATUS			= 0x8B80,
 GL_COMPILE_STATUS			= 0x8B81,
 GL_LINK_STATUS			= 0x8B82,
 GL_VALIDATE_STATUS			= 0x8B83,
 GL_INFO_LOG_LENGTH			= 0x8B84,
 GL_ATTACHED_SHADERS		= 0x8B85,
 GL_ACTIVE_UNIFORMS			= 0x8B86,
 GL_ACTIVE_UNIFORM_MAX_LENGTH	= 0x8B87,
 GL_SHADER_SOURCE_LENGTH		= 0x8B88,
 GL_ACTIVE_ATTRIBUTES		= 0x8B89,
 GL_ACTIVE_ATTRIBUTE_MAX_LENGTH	= 0x8B8A,
 GL_FRAGMENT_SHADER_DERIVATIVE_HINT	= 0x8B8B,
 GL_SHADING_LANGUAGE_VERSION	= 0x8B8C,
 GL_CURRENT_PROGRAM			= 0x8B8D,
 GL_POINT_SPRITE_COORD_ORIGIN	= 0x8CA0,
 GL_LOWER_LEFT			= 0x8CA1,
 GL_UPPER_LEFT			= 0x8CA2,
 GL_STENCIL_BACK_REF		= 0x8CA3,
 GL_STENCIL_BACK_VALUE_MASK		= 0x8CA4,
 GL_STENCIL_BACK_WRITEMASK		= 0x8CA5,

// ARB_Imaging
 GL_CONSTANT_COLOR			= 0x8001,
 GL_ONE_MINUS_CONSTANT_COLOR	= 0x8002,
 GL_CONSTANT_ALPHA			= 0x8003,
 GL_ONE_MINUS_CONSTANT_ALPHA	= 0x8004,
 GL_BLEND_COLOR			= 0x8005,
 GL_FUNC_ADD			= 0x8006,
 GL_MIN				= 0x8007,
 GL_MAX				= 0x8008,
 GL_BLEND_EQUATION			= 0x8009,
 GL_FUNC_SUBTRACT			= 0x800A,
 GL_FUNC_REVERSE_SUBTRACT		= 0x800B,
 GL_CONVOLUTION_1D			= 0x8010,
 GL_CONVOLUTION_2D			= 0x8011,
 GL_SEPARABLE_2D			= 0x8012,
 GL_CONVOLUTION_BORDER_MODE		= 0x8013,
 GL_CONVOLUTION_FILTER_SCALE	= 0x8014,
 GL_CONVOLUTION_FILTER_BIAS		= 0x8015,
 GL_REDUCE				= 0x8016,
 GL_CONVOLUTION_FORMAT		= 0x8017,
 GL_CONVOLUTION_WIDTH		= 0x8018,
 GL_CONVOLUTION_HEIGHT		= 0x8019,
 GL_MAX_CONVOLUTION_WIDTH		= 0x801A,
 GL_MAX_CONVOLUTION_HEIGHT		= 0x801B,
 GL_POST_CONVOLUTION_RED_SCALE	= 0x801C,
 GL_POST_CONVOLUTION_GREEN_SCALE	= 0x801D,
 GL_POST_CONVOLUTION_BLUE_SCALE	= 0x801E,
 GL_POST_CONVOLUTION_ALPHA_SCALE	= 0x801F,
 GL_POST_CONVOLUTION_RED_BIAS	= 0x8020,
 GL_POST_CONVOLUTION_GREEN_BIAS	= 0x8021,
 GL_POST_CONVOLUTION_BLUE_BIAS	= 0x8022,
 GL_POST_CONVOLUTION_ALPHA_BIAS	= 0x8023,
 GL_HISTOGRAM			= 0x8024,
 GL_PROXY_HISTOGRAM			= 0x8025,
 GL_HISTOGRAM_WIDTH			= 0x8026,
 GL_HISTOGRAM_FORMAT		= 0x8027,
 GL_HISTOGRAM_RED_SIZE		= 0x8028,
 GL_HISTOGRAM_GREEN_SIZE		= 0x8029,
 GL_HISTOGRAM_BLUE_SIZE		= 0x802A,
 GL_HISTOGRAM_ALPHA_SIZE		= 0x802B,
 GL_HISTOGRAM_LUMINANCE_SIZE	= 0x802C,
 GL_HISTOGRAM_SINK			= 0x802D,
 GL_MINMAX				= 0x802E,
 GL_MINMAX_FORMAT			= 0x802F,
 GL_MINMAX_SINK			= 0x8030,
 GL_TABLE_TOO_LARGE			= 0x8031,
 GL_COLOR_MATRIX			= 0x80B1,
 GL_COLOR_MATRIX_STACK_DEPTH	= 0x80B2,
 GL_MAX_COLOR_MATRIX_STACK_DEPTH	= 0x80B3,
 GL_POST_COLOR_MATRIX_RED_SCALE	= 0x80B4,
 GL_POST_COLOR_MATRIX_GREEN_SCALE	= 0x80B5,
 GL_POST_COLOR_MATRIX_BLUE_SCALE	= 0x80B6,
 GL_POST_COLOR_MATRIX_ALPHA_SCALE	= 0x80B7,
 GL_POST_COLOR_MATRIX_RED_BIAS	= 0x80B8,
 GL_POST_COLOR_MATRIX_GREEN_BIAS	= 0x80B9,
 GL_POST_COLOR_MATRIX_BLUE_BIAS	= 0x80BA,
 GL_POST_COLOR_MATRIX_ALPHA_BIAS	= 0x80BB,
 GL_COLOR_TABLE			= 0x80D0,
 GL_POST_CONVOLUTION_COLOR_TABLE	= 0x80D1,
 GL_POST_COLOR_MATRIX_COLOR_TABLE	= 0x80D2,
 GL_PROXY_COLOR_TABLE		= 0x80D3,
 GL_PROXY_POST_CONVOLUTION_COLOR_TABLE= 0x80D4,
 GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE= 0x80D5,
 GL_COLOR_TABLE_SCALE		= 0x80D6,
 GL_COLOR_TABLE_BIAS		= 0x80D7,
 GL_COLOR_TABLE_FORMAT		= 0x80D8,
 GL_COLOR_TABLE_WIDTH		= 0x80D9,
 GL_COLOR_TABLE_RED_SIZE		= 0x80DA,
 GL_COLOR_TABLE_GREEN_SIZE		= 0x80DB,
 GL_COLOR_TABLE_BLUE_SIZE		= 0x80DC,
 GL_COLOR_TABLE_ALPHA_SIZE		= 0x80DD,
 GL_COLOR_TABLE_LUMINANCE_SIZE	= 0x80DE,
 GL_COLOR_TABLE_INTENSITY_SIZE	= 0x80DF,
 GL_CONSTANT_BORDER			= 0x8151,
 GL_REPLICATE_BORDER		= 0x8153,
 GL_CONVOLUTION_BORDER_COLOR	= 0x8154,

//glu

//==============================================================================
// CONSTANTS
//==============================================================================
// StringName
 GLU_VERSION			= 100800,
 GLU_EXTENSIONS			= 100801,
 GLU_EXT_object_space_tess   =       1,
 GLU_EXT_nurbs_tessellator    =      1,
// ErrorCode
 GLU_INVALID_ENUM			= 100900,
 GLU_INVALID_VALUE			= 100901,
 GLU_OUT_OF_MEMORY			= 100902,
 GLU_INVALID_OPERATION		= 100904,
 GLU_INCOMPATIBLE_GL_VERSION     =   100903,
// NurbsDisplay
 GLU_OUTLINE_POLYGON		= 100240,
 GLU_OUTLINE_PATCH			= 100241,
// NurbsCallback
 GLU_NURBS_ERROR			= 100103,
 GLU_ERROR				= 100103,
 GLU_NURBS_BEGIN			= 100164,
 GLU_NURBS_BEGIN_EXT		= 100164,
 GLU_NURBS_VERTEX			= 100165,
 GLU_NURBS_VERTEX_EXT		= 100165,
 GLU_NURBS_NORMAL			= 100166,
 GLU_NURBS_NORMAL_EXT		= 100166,
 GLU_NURBS_COLOR			= 100167,
 GLU_NURBS_COLOR_EXT		= 100167,
 GLU_NURBS_TEXTURE_COORD		= 100168,
 GLU_NURBS_TEX_COORD_EXT		= 100168,
 GLU_NURBS_END			= 100169,
 GLU_NURBS_END_EXT			= 100169,
 GLU_NURBS_BEGIN_DATA		= 100170,
 GLU_NURBS_BEGIN_DATA_EXT		= 100170,
 GLU_NURBS_VERTEX_DATA		= 100171,
 GLU_NURBS_VERTEX_DATA_EXT		= 100171,
 GLU_NURBS_NORMAL_DATA		= 100172,
 GLU_NURBS_NORMAL_DATA_EXT		= 100172,
 GLU_NURBS_COLOR_DATA		= 100173,
 GLU_NURBS_COLOR_DATA_EXT		= 100173,
 GLU_NURBS_TEXTURE_COORD_DATA	= 100174,
 GLU_NURBS_TEX_COORD_DATA_EXT 	= 100174,
 GLU_NURBS_END_DATA			= 100175,
 GLU_NURBS_END_DATA_EXT		= 100175,
// NurbsError
 GLU_NURBS_ERROR1			= 100251,
 GLU_NURBS_ERROR2			= 100252,
 GLU_NURBS_ERROR3			= 100253,
 GLU_NURBS_ERROR4			= 100254,
 GLU_NURBS_ERROR5			= 100255,
 GLU_NURBS_ERROR6			= 100256,
 GLU_NURBS_ERROR7			= 100257,
 GLU_NURBS_ERROR8			= 100258,
 GLU_NURBS_ERROR9			= 100259,
 GLU_NURBS_ERROR10			= 100260,
 GLU_NURBS_ERROR11			= 100261,
 GLU_NURBS_ERROR12			= 100262,
 GLU_NURBS_ERROR13			= 100263,
 GLU_NURBS_ERROR14			= 100264,
 GLU_NURBS_ERROR15			= 100265,
 GLU_NURBS_ERROR16			= 100266,
 GLU_NURBS_ERROR17			= 100267,
 GLU_NURBS_ERROR18			= 100268,
 GLU_NURBS_ERROR19			= 100269,
 GLU_NURBS_ERROR20			= 100270,
 GLU_NURBS_ERROR21			= 100271,
 GLU_NURBS_ERROR22			= 100272,
 GLU_NURBS_ERROR23			= 100273,
 GLU_NURBS_ERROR24			= 100274,
 GLU_NURBS_ERROR25			= 100275,
 GLU_NURBS_ERROR26			= 100276,
 GLU_NURBS_ERROR27			= 100277,
 GLU_NURBS_ERROR28			= 100278,
 GLU_NURBS_ERROR29			= 100279,
 GLU_NURBS_ERROR30			= 100280,
 GLU_NURBS_ERROR31			= 100281,
 GLU_NURBS_ERROR32			= 100282,
 GLU_NURBS_ERROR33			= 100283,
 GLU_NURBS_ERROR34			= 100284,
 GLU_NURBS_ERROR35			= 100285,
 GLU_NURBS_ERROR36			= 100286,
 GLU_NURBS_ERROR37			= 100287,
// NurbsProperty
 GLU_AUTO_LOAD_MATRIX		= 100200,
 GLU_CULLING			= 100201,
 GLU_SAMPLING_TOLERANCE		= 100203,
 GLU_DISPLAY_MODE			= 100204,
 GLU_PARAMETRIC_TOLERANCE		= 100202,
 GLU_SAMPLING_METHOD		= 100205,
 GLU_U_STEP				= 100206,
 GLU_V_STEP				= 100207,
 GLU_NURBS_MODE			= 100160,
 GLU_NURBS_MODE_EXT			= 100160,
 GLU_NURBS_TESSELLATOR		= 100161,
 GLU_NURBS_TESSELLATOR_EXT		= 100161,
 GLU_NURBS_RENDERER			= 100162,
 GLU_NURBS_RENDERER_EXT		= 100162,
// NurbsSampling
 GLU_OBJECT_PARAMETRIC_ERROR	= 100208,
 GLU_OBJECT_PARAMETRIC_ERROR_EXT	= 100208,
 GLU_OBJECT_PATH_LENGTH		= 100209,
 GLU_OBJECT_PATH_LENGTH_EXT		= 100209,
 GLU_PATH_LENGTH			= 100215,
 GLU_PARAMETRIC_ERROR		= 100216,
 GLU_DOMAIN_DISTANCE		= 100217,
// NurbsTrim
 GLU_MAP1_TRIM_2			= 100210,
 GLU_MAP2_TRIM_3			= 100211,
// QuadricDrawStyle
 GLU_POINT				= 100010,
 GLU_LINE				= 100011,
 GLU_FILL				= 100012,
 GLU_SILHOUETTE			= 100013,
 
 /* QuadricNormal */
GLU_SMOOTH   =                      100000,
GLU_FLAT         =                  100001,
GLU_NONE        =                   100002,

/* QuadricOrientation */
GLU_OUTSIDE        =                100020,
GLU_INSIDE         =                100021,

// QuadricNormal
 GLU_TESS_BEGIN			= 100100,
 GLU_BEGIN				= 100100,
 GLU_TESS_VERTEX			= 100101,
 GLU_VERTEX				= 100101,
 GLU_TESS_END			= 100102,
 GLU_END				= 100102,
 GLU_TESS_ERROR			= 100103,
 GLU_TESS_EDGE_FLAG			= 100104,
 GLU_EDGE_FLAG			= 100104,
 GLU_TESS_COMBINE			= 100105,
 GLU_TESS_BEGIN_DATA		= 100106,
 GLU_TESS_VERTEX_DATA		= 100107,
 GLU_TESS_END_DATA			= 100108,
 GLU_TESS_ERROR_DATA		= 100109,
 GLU_TESS_EDGE_FLAG_DATA		= 100110,
 GLU_TESS_COMBINE_DATA		= 100111,
// TessContour
 GLU_CW				= 100120,
 GLU_CCW				= 100121,
 GLU_INTERIOR			= 100122,
 GLU_EXTERIOR			= 100123,
 GLU_UNKNOWN			= 100124,
// TessProperty
 GLU_TESS_WINDING_RULE		= 100140,
 GLU_TESS_BOUNDARY_ONLY		= 100141,
 GLU_TESS_TOLERANCE			= 100142,
// TessError
 GLU_TESS_ERROR1			= 100151,
 GLU_TESS_ERROR2			= 100152,
 GLU_TESS_ERROR3			= 100153,
 GLU_TESS_ERROR4			= 100154,
 GLU_TESS_ERROR5			= 100155,
 GLU_TESS_ERROR6			= 100156,
 GLU_TESS_ERROR7			= 100157,
 GLU_TESS_ERROR8			= 100158,
 GLU_TESS_MISSING_BEGIN_POLYGON	= 100151,
 GLU_TESS_MISSING_BEGIN_COUNTER	= 100152,
 GLU_TESS_MISSING_END_POLYGON	= 100153,
 GLU_TESS_MISSING_END_COUNTER	= 100154,
 GLU_TESS_COORD_TOO_LARGE		= 100155,
 GLU_TESS_NEED_COMBINE_CALLBACK	= 100156,
// TessWinding
 GLU_TESS_WINDING_ODD		= 100130,
 GLU_TESS_WINDING_NONZERO		= 100131,
 GLU_TESS_WINDING_POSITIVE		= 100132,
 GLU_TESS_WINDING_NEGATIVE		= 100133,
 GLU_TESS_WINDING_ABS_GEQ_TWO	= 100134,
 
}
const дво GLU_TESS_MAX_COORD		= 1.0e150;

/////glut

enum: бцел
{
/*
 * The freeglut and GLUT API versions
 */
FREEGLUT				= 1,
GLUT_API_VERSION			= 4,
FREEGLUT_VERSION_2_0		= 1,
GLUT_XLIB_IMPLEMENTATION		= 13,

/*
 * GLUT API: коды специальных клавиш
 */
КЛ_Ф1			= 0x0001,
КЛ_Ф2			= 0x0002,
КЛ_Ф3			= 0x0003,
КЛ_Ф4			= 0x0004,
КЛ_Ф5			= 0x0005,
КЛ_Ф6			= 0x0006,
КЛ_Ф7			= 0x0007,
КЛ_Ф8			= 0x0008,
КЛ_Ф9			= 0x0009,
КЛ_Ф10			= 0x000A,
КЛ_Ф11			= 0x000B,
КЛ_Ф12			= 0x000C,
КЛ_ЛЕВАЯ			= 0x0064,
КЛ_ВВЕРХУ			= 0x0065,
КЛ_ПРАВАЯ			= 0x0066,
КЛ_ВНИЗУ			= 0x0067,
КЛ_СТР_ВВЕРХ			= 0x0068,
КЛ_СТР_ВНИЗ			= 0x0069,
КЛ_ДОМ			= 0x006A,
КЛ_КОНЕЦ			= 0x006B,
КЛ_ВСТАВИТЬ		= 0x006C,

/*
 * GLUT API: определения состояний мыши
 */

МЫШЬ_ЛЕВАЯ			= 0x0000,
МЫШЬ_СРЕДНЯЯ			= 0x0001,
МЫШЬ_ПРАВАЯ			= 0x0002,
МЫШЬ_ВНИЗУ				= 0x0000,
МЫШЬ_ВВЕРХУ				= 0x0001,
МЫШЬ_ВЫШЛА				= 0x0000,
МЫШЬ_ВОШЛА			= 0x0001,

/*
 * GLUT API macro definitions -- the display mode definitions
 */
GLUT_RGB				= 0x0000,
GLUT_RGBA				= 0x0000,
GLUT_INDEX				= 0x0001,
GLUT_SINGLE			= 0x0000,
GLUT_DOUBLE			= 0x0002,
GLUT_ACCUM				= 0x0004,
GLUT_ALPHA				= 0x0008,
GLUT_DEPTH				= 0x0010,
GLUT_STENCIL			= 0x0020,
GLUT_MULTISAMPLE			= 0x0080,
GLUT_STEREO			= 0x0100,
GLUT_LUMINANCE			= 0x0200,

/*
 * GLUT API macro definitions -- windows and menu related definitions
 */
GLUT_MENU_NOT_IN_USE		= 0x0000,
GLUT_MENU_IN_USE			= 0x0001,
GLUT_NOT_VISIBLE			= 0x0000,
GLUT_VISIBLE			= 0x0001,
GLUT_HIDDEN			= 0x0000,
GLUT_FULLY_RETAINED		= 0x0001,
GLUT_PARTIALLY_RETAINED		= 0x0002,
GLUT_FULLY_COVERED			= 0x0003,
}
/*
 * GLUT API macro definitions
 * Steve Baker suggested to make it binary compatible with GLUT:
 */
version (Windows) {
	const ук GLUT_STROKE_ROMAN		= cast(ук)0x0000;
	const ук GLUT_STROKE_MONO_ROMAN	= cast(ук)0x0001;
	const ук GLUT_BITMAP_9_BY_15	= cast(ук)0x0002;
	const ук GLUT_BITMAP_8_BY_13	= cast(ук)0x0003;
	const ук GLUT_BITMAP_TIMES_ROMAN_10= cast(ук)0x0004;
	const ук GLUT_BITMAP_TIMES_ROMAN_24= cast(ук)0x0005;
	const ук GLUT_BITMAP_HELVETICA_10	= cast(ук)0x0006;
	const ук GLUT_BITMAP_HELVETICA_12	= cast(ук)0x0007;
	const ук GLUT_BITMAP_HELVETICA_18	= cast(ук)0x0008;

}

enum: бцел
{
// GLUT API macro definitions -- the glutGet parameters
GLUT_WINDOW_X			= 0x0064,
GLUT_WINDOW_Y			= 0x0065,
GLUT_WINDOW_WIDTH			= 0x0066,
GLUT_WINDOW_HEIGHT			= 0x0067,
GLUT_WINDOW_BUFFER_SIZE		= 0x0068,
GLUT_WINDOW_STENCIL_SIZE		= 0x0069,
GLUT_WINDOW_DEPTH_SIZE		= 0x006A,
GLUT_WINDOW_RED_SIZE		= 0x006B,
GLUT_WINDOW_GREEN_SIZE		= 0x006C,
GLUT_WINDOW_BLUE_SIZE		= 0x006D,
GLUT_WINDOW_ALPHA_SIZE		= 0x006E,
GLUT_WINDOW_ACCUM_RED_SIZE		= 0x006F,
GLUT_WINDOW_ACCUM_GREEN_SIZE	= 0x0070,
GLUT_WINDOW_ACCUM_BLUE_SIZE	= 0x0071,
GLUT_WINDOW_ACCUM_ALPHA_SIZE	= 0x0072,
GLUT_WINDOW_DOUBLEBUFFER		= 0x0073,
GLUT_WINDOW_RGBA			= 0x0074,
GLUT_WINDOW_PARENT			= 0x0075,
GLUT_WINDOW_NUM_CHILDREN		= 0x0076,
GLUT_WINDOW_COLORMAP_SIZE		= 0x0077,
GLUT_WINDOW_NUM_SAMPLES		= 0x0078,
GLUT_WINDOW_STEREO			= 0x0079,
GLUT_WINDOW_CURSOR			= 0x007A,

GLUT_SCREEN_WIDTH			= 0x00C8,
GLUT_SCREEN_HEIGHT			= 0x00C9,
GLUT_SCREEN_WIDTH_MM		= 0x00CA,
GLUT_SCREEN_HEIGHT_MM		= 0x00CB,
GLUT_MENU_NUM_ITEMS		= 0x012C,
GLUT_DISPLAY_MODE_POSSIBLE		= 0x0190,
GLUT_INIT_WINDOW_X			= 0x01F4,
GLUT_INIT_WINDOW_Y			= 0x01F5,
GLUT_INIT_WINDOW_WIDTH		= 0x01F6,
GLUT_INIT_WINDOW_HEIGHT		= 0x01F7,
GLUT_INIT_DISPLAY_MODE		= 0x01F8,
GLUT_ELAPSED_TIME			= 0x02BC,
GLUT_WINDOW_FORMAT_ID		= 0x007B,
GLUT_INIT_STATE			= 0x007C,

// GLUT API macro definitions -- the glutDeviceGet parameters
GLUT_HAS_KEYBOARD			= 0x0258,
GLUT_HAS_MOUSE			= 0x0259,
GLUT_HAS_SPACEBALL			= 0x025A,
GLUT_HAS_DIAL_AND_BUTTON_BOX	= 0x025B,
GLUT_HAS_TABLET			= 0x025C,
GLUT_NUM_MOUSE_BUTTONS		= 0x025D,
GLUT_NUM_SPACEBALL_BUTTONS		= 0x025E,
GLUT_NUM_BUTTON_BOX_BUTTONS	= 0x025F,
GLUT_NUM_DIALS			= 0x0260,
GLUT_NUM_TABLET_BUTTONS		= 0x0261,
GLUT_DEVICE_IGNORE_KEY_REPEAT	= 0x0262,
GLUT_DEVICE_KEY_REPEAT		= 0x0263,
GLUT_HAS_JOYSTICK			= 0x0264,
GLUT_OWNS_JOYSTICK			= 0x0265,
GLUT_JOYSTICK_BUTTONS		= 0x0266,
GLUT_JOYSTICK_AXES			= 0x0267,
GLUT_JOYSTICK_POLL_RATE		= 0x0268,

// GLUT API macro definitions -- the glutLayerGet parameters
GLUT_OVERLAY_POSSIBLE		= 0x0320,
GLUT_LAYER_IN_USE			= 0x0321,
GLUT_HAS_OVERLAY			= 0x0322,
GLUT_TRANSPARENT_INDEX		= 0x0323,
GLUT_NORMAL_DAMAGED		= 0x0324,
GLUT_OVERLAY_DAMAGED		= 0x0325,

// GLUT API macro definitions -- the glutVideoResizeGet parameters
GLUT_VIDEO_RESIZE_POSSIBLE		= 0x0384,
GLUT_VIDEO_RESIZE_IN_USE		= 0x0385,
GLUT_VIDEO_RESIZE_X_DELTA		= 0x0386,
GLUT_VIDEO_RESIZE_Y_DELTA		= 0x0387,
GLUT_VIDEO_RESIZE_WIDTH_DELTA	= 0x0388,
GLUT_VIDEO_RESIZE_HEIGHT_DELTA	= 0x0389,
GLUT_VIDEO_RESIZE_X		= 0x038A,
GLUT_VIDEO_RESIZE_Y		= 0x038B,
GLUT_VIDEO_RESIZE_WIDTH		= 0x038C,
GLUT_VIDEO_RESIZE_HEIGHT		= 0x038D,

// GLUT API macro definitions -- the glutUseLayer parameters
GLUT_NORMAL			= 0x0000,
GLUT_OVERLAY			= 0x0001,

// GLUT API macro definitions -- the glutGetModifiers parameters
GLUT_ACTIVE_ШИФТ			= 0x0001,
GLUT_ACTIVE_CTRL			= 0x0002,
GLUT_ACTIVE_ALT			= 0x0004,

// GLUT API macro definitions -- the glutSetCursor parameters
GLUT_CURSOR_RIGHT_ARROW		= 0x0000,
GLUT_CURSOR_LEFT_ARROW		= 0x0001,
GLUT_CURSOR_INFO			= 0x0002,
GLUT_CURSOR_DESTROY		= 0x0003,
GLUT_CURSOR_HELP			= 0x0004,
GLUT_CURSOR_CYCLE			= 0x0005,
GLUT_CURSOR_SPRAY			= 0x0006,
GLUT_CURSOR_WAIT			= 0x0007,
GLUT_CURSOR_TEXT			= 0x0008,
GLUT_CURSOR_CROSSHAIR		= 0x0009,
GLUT_CURSOR_UP_DOWN		= 0x000A,
GLUT_CURSOR_LEFT_RIGHT		= 0x000B,
GLUT_CURSOR_TOP_SIDE		= 0x000C,
GLUT_CURSOR_BOTTOM_SIDE		= 0x000D,
GLUT_CURSOR_LEFT_SIDE		= 0x000E,
GLUT_CURSOR_RIGHT_SIDE		= 0x000F,
GLUT_CURSOR_TOP_LEFT_CORNER	= 0x0010,
GLUT_CURSOR_TOP_RIGHT_CORNER	= 0x0011,
GLUT_CURSOR_BOTTOM_RIGHT_CORNER	= 0x0012,
GLUT_CURSOR_BOTTOM_LEFT_CORNER	= 0x0013,
GLUT_CURSOR_INHERIT		= 0x0064,
GLUT_CURSOR_NONE			= 0x0065,
GLUT_CURSOR_FULL_CROSSHAIR		= 0x0066,

// GLUT API macro definitions -- RGB color component specification definitions
GLUT_RED				= 0x0000,
GLUT_GREEN				= 0x0001,
GLUT_BLUE				= 0x0002,

// GLUT API macro definitions -- additional keyboard and joystick definitions
КЛ_REPEAT_OFF		= 0x0000,
КЛ_REPEAT_ON			= 0x0001,
КЛ_REPEAT_DEFAULT		= 0x0002,

GLUT_JOYSTICK_BUTTON_A		= 0x0001,
GLUT_JOYSTICK_BUTTON_B		= 0x0002,
GLUT_JOYSTICK_BUTTON_C		= 0x0004,
GLUT_JOYSTICK_BUTTON_D		= 0x0008,

// GLUT API macro definitions -- game mode definitions
GLUT_GAME_MODE_ACTIVE		= 0x0000,
GLUT_GAME_MODE_POSSIBLE		= 0x0001,
GLUT_GAME_MODE_WIDTH		= 0x0002,
GLUT_GAME_MODE_HEIGHT		= 0x0003,
GLUT_GAME_MODE_PIXEL_DEPTH		= 0x0004,
GLUT_GAME_MODE_REFRESH_RATE	= 0x0005,
GLUT_GAME_MODE_DISPLAY_CHANGED	= 0x0006,

// FreeGlut extra definitions

}
version(FREEGLUT_EXTRAS)
 {
 
 enum: бцел
	{
	/*
	 * GLUT API Extension macro definitions -- behaviour when the user clicks on an "x" to close a window
	 */
	GLUT_ACTION_EXIT		= 0,
	GLUT_ACTION_GLUTMAINLOOP_RETURNS= 1,
	GLUT_ACTION_CONTINUE_EXECUTION= 2,

	/*
	 * Create a new rendering context when the user opens a new window?
	 */
	GLUT_CREATE_NEW_CONTEXT	= 0,
	GLUT_USE_CURRENT_CONTEXT	= 1,

	/*
	 * Direct/Indirect rendering context options (has meaning only in Unix/X11)
	 */
	GLUT_FORCE_INDIRECT_CONTEXT= 0,
	GLUT_ALLOW_DIRECT_CONTEXT	= 1,
	GLUT_TRY_DIRECT_CONTEXT	= 2,
	GLUT_FORCE_DIRECT_CONTEXT	= 3,

	/*
	 * GLUT API Extension macro definitions -- the glutGet parameters
	 */
	GLUT_ACTION_ON_WINDOW_CLOSE= 0x01F9,
	GLUT_WINDOW_BORDER_WIDTH	= 0x01FA,
	GLUT_WINDOW_HEADER_HEIGHT	= 0x01FB,
	GLUT_VERSION		= 0x01FC,
	GLUT_RENDERING_CONTEXT	= 0x01FD,
	GLUT_DIRECT_RENDERING	= 0x01FE,

	/*
	 * New tokens for glutInitDisplayMode.
	 * Only one GLUT_AUXn bit may be used at a time.
	 * Value 0x0400 is defined in OpenGLUT.
	 */
	GLUT_AUX1			= 0x1000,
	GLUT_AUX2			= 0x2000,
	GLUT_AUX3			= 0x4000,
	GLUT_AUX4			= 0x8000,
	}


}
//////////////////////////////////////////////////
struct jitter_point
{
	плав x;
	плав y ;
	
} 

const MAX_SAMPLES =  66;

/* 2 jitter points */
jitter_point j2[] =
[
	{ 0.246490,  0.249999},
	{-0.246490, -0.249999}
];


/* 3 jitter points */
jitter_point j3[] =
[
	{-0.373411, -0.250550},
	{ 0.256263,  0.368119},
	{ 0.117148, -0.117570}
];


/* 4 jitter points */
jitter_point j4[] =
[
	{-0.208147,  0.353730},
	{ 0.203849, -0.353780},
	{-0.292626, -0.149945},
	{ 0.296924,  0.149994}
];


/* 8 jitter points */
jitter_point j8[] =
[
	{-0.334818,  0.435331},
	{ 0.286438, -0.393495},
	{ 0.459462,  0.141540},
	{-0.414498, -0.192829},
	{-0.183790,  0.082102},
	{-0.079263, -0.317383},
	{ 0.102254,  0.299133},
	{ 0.164216, -0.054399}
];


/* 15 jitter points */
jitter_point j15[] =
[
	{ 0.285561,  0.188437},
	{ 0.360176, -0.065688},
	{-0.111751,  0.275019},
	{-0.055918, -0.215197},
	{-0.080231, -0.470965},
	{ 0.138721,  0.409168},
	{ 0.384120,  0.458500},
	{-0.454968,  0.134088},
	{ 0.179271, -0.331196},
	{-0.307049, -0.364927},
	{ 0.105354, -0.010099},
	{-0.154180,  0.021794},
	{-0.370135, -0.116425},
	{ 0.451636, -0.300013},
	{-0.370610,  0.387504}
];


/* 24 jitter points */
jitter_point j24[] =
[
	{ 0.030245,  0.136384},
	{ 0.018865, -0.348867},
	{-0.350114, -0.472309},
	{ 0.222181,  0.149524},
	{-0.393670, -0.266873},
	{ 0.404568,  0.230436},
	{ 0.098381,  0.465337},
	{ 0.462671,  0.442116},
	{ 0.400373, -0.212720},
	{-0.409988,  0.263345},
	{-0.115878, -0.001981},
	{ 0.348425, -0.009237},
	{-0.464016,  0.066467},
	{-0.138674, -0.468006},
	{ 0.144932, -0.022780},
	{-0.250195,  0.150161},
	{-0.181400, -0.264219},
	{ 0.196097, -0.234139},
	{-0.311082, -0.078815},
	{ 0.268379,  0.366778},
	{-0.040601,  0.327109},
	{-0.234392,  0.354659},
	{-0.003102, -0.154402},
	{ 0.297997, -0.417965}
];


/* 66 jitter points */
jitter_point j66[] =
[
	{ 0.266377, -0.218171},
	{-0.170919, -0.429368},
	{ 0.047356, -0.387135},
	{-0.430063,  0.363413},
	{-0.221638, -0.313768},
	{ 0.124758, -0.197109},
	{-0.400021,  0.482195},
	{ 0.247882,  0.152010},
	{-0.286709, -0.470214},
	{-0.426790,  0.004977},
	{-0.361249, -0.104549},
	{-0.040643,  0.123453},
	{-0.189296,  0.438963},
	{-0.453521, -0.299889},
	{ 0.408216, -0.457699},
	{ 0.328973, -0.101914},
	{-0.055540, -0.477952},
	{ 0.194421,  0.453510},
	{ 0.404051,  0.224974},
	{ 0.310136,  0.419700},
	{-0.021743,  0.403898},
	{-0.466210,  0.248839},
	{ 0.341369,  0.081490},
	{ 0.124156, -0.016859},
	{-0.461321, -0.176661},
	{ 0.013210,  0.234401},
	{ 0.174258, -0.311854},
	{ 0.294061,  0.263364},
	{-0.114836,  0.328189},
	{ 0.041206, -0.106205},
	{ 0.079227,  0.345021},
	{-0.109319, -0.242380},
	{ 0.425005, -0.332397},
	{ 0.009146,  0.015098},
	{-0.339084, -0.355707},
	{-0.224596, -0.189548},
	{ 0.083475,  0.117028},
	{ 0.295962, -0.334699},
	{ 0.452998,  0.025397},
	{ 0.206511, -0.104668},
	{ 0.447544, -0.096004},
	{-0.108006, -0.002471},
	{-0.380810,  0.130036},
	{-0.242440,  0.186934},
	{-0.200363,  0.070863},
	{-0.344844, -0.230814},
	{ 0.408660,  0.345826},
	{-0.233016,  0.305203},
	{ 0.158475, -0.430762},
	{ 0.486972,  0.139163},
	{-0.301610,  0.009319},
	{ 0.282245, -0.458671},
	{ 0.482046,  0.443890},
	{-0.121527,  0.210223},
	{-0.477606, -0.424878},
	{-0.083941, -0.121440},
	{-0.345773,  0.253779},
	{ 0.234646,  0.034549},
	{ 0.394102, -0.210901},
	{-0.312571,  0.397656},
	{ 0.200906,  0.333293},
	{ 0.018703, -0.261792},
	{-0.209349, -0.065383},
	{ 0.076248,  0.478538},
	{-0.073036, -0.355064},
	{ 0.145087,  0.221726}
];


extern(D):

    проц глОчистиИндекс(плав а) ;
    проц глЦветОчистки(Гклампп а,Гклампп б,Гклампп в,Гклампп г);
    проц глОчисти(Гбитполе а);
    проц глМаскаИндекса(бцел а);
    проц глМаскаЦвета(Гбул а,Гбул б,Гбул в,Гбул г);
    проц глФункцАльфы(Гперечень а,Гклампп б);
    проц глФункцСмеси(Гперечень а,Гперечень б);
    проц глЛогическаяОп(Гперечень а);
    проц глПрофиль(Гперечень а);
    проц глФас(Гперечень а);
    проц глРазмерТочки(плав а);
    проц глШиринаЛинии(плав а);
    проц глПолоскаЛиний(цел а,бкрат б);
    проц глРежимМногоуг(Гперечень а,Гперечень б);
    проц глСмещениеМногоуг(плав а,плав б);
    проц глПолоскаМногоуг(ббайт* а);
    проц глДайПолоскуМногоуг(ббайт* а);
    проц глФлагКрая(Гбул а);
    проц глФлагКрая(Гбул* а);
    проц глНожницы(цел а,цел б,Гцразм в,Гцразм г);
    проц глОПлоскостьОбрезки(Гперечень а,дво* б);
    проц глДайПлоскостьОбрезки(Гперечень а,дво* б);//{;
    проц глБуфРис(Гперечень а);
    проц глБуфЧтения(Гперечень а);// glReadBuffer;
    проц глВключи(Гперечень а);// glEnable;
    проц глОтключи(Гперечень а);// glDisable;
    Гбул  глВключен_ли(Гперечень а);//glIsEnabled;
    проц глВключиСостояниеКлиента(Гперечень а);// glEnableClientState;
    проц глОтключиСостояниеКлиента(Гперечень а);// glDisableClientState;
    проц глДайБул(Гперечень а,Гбул* б);// glGetBooleanv;
    проц глДайДво(Гперечень а,дво* б);// glGetDoublev;
    проц глДайПлав(Гперечень а,плав* б);// glGetFloatv;
    проц глДайЦел(Гперечень а,цел* б);// glGetIntegerv;
    проц глСуньАтриб(Гбитполе а);// glPushAttrib;
    проц глВыньАтриб();// glPopAttrib;
    проц глСуньАтрибКлиента(Гбитполе а);// glPushClientAttrib;
    проц глВыньАтрибКлиента();//glPopClientAttrib;
    цел глРежимОтображения(Гперечень а);// glRenderMode;
    Гперечень глДайОшибку();// glGetError;
    ткст0 глДайТекст(Гперечень а);//glGetString;
    проц глФиниш();//{glFinish;
    проц глСлей();// glFlush;;
    проц глПодсказка(Гперечень а,Гперечень б);//{ glHint;

    проц глОчистиДаль(Гклампд а);//{ glClearDepth(cast(GLclampd) а);}
    проц глФункцДали(Гперечень а);//{ glDepthFunc(cast(GLenum) а);}
    проц глМаскаДали(Гбул а);//{ glDepthMask(cast(GLboolean) а);}
    проц глДиапазонДали(Гклампд а,Гклампд б);//{ glDepthRange(cast(GLclampd) а,cast(GLclampd) б);}

    проц глОчистиАккум(плав а,плав б,плав в,плав г);//{ glClearAccum;
    проц глАккум(Гперечень а,плав б);//{ glAccum(cast(GLenum) а, cast(GLfloat) б);}

    проц глРежимМатр(Гперечень а);//{ glMatrixMode(cast(GLenum) а);}
    проц глОрто(дво а,дво б,дво в,дво г,дво д,дво е);//{ glOrtho;
    проц глФруструм(дво а,дво б,дво в,дво г,дво д,дво е);//{ glFrustum;
    проц глВьюпорт(цел а,цел б,Гцразм в,Гцразм г);//{ glViewport(cast(GLint) а, cast(GLint) б, в, г);}
    проц глСуньМатр();//{ glPushMatrix();}
    проц глВыньМатр();//{ glPopMatrix();}
    проц глЗагрузиИдент();//{glLoadIdentity();}
    проц глЗагрузиМатр(дво* а);//{glLoadMatrixd(cast(GLdouble*) а);}
    проц глЗагрузиМатр(плав* а);//{ glLoadMatrixf(cast(GLfloat*) а);}
    проц глУмножьМатр(дво* а);//{ glMultMatrixd(cast(GLdouble*) а);}
    проц глУмножьМатр(плав* а);//{ glMultMatrixf(cast(GLfloat*) а);}
    проц глВращайд(дво а,дво б,дво в,дво г);//{ glRotated;
    проц глВращай(плав а,плав б,плав в,плав г);//{ glRotatef;
    проц глМасштабируйд(дво а,дво б,дво в);//{ glScaled(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глМасштабируй(плав а,плав б,плав в);//{ glScalef(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    проц глПеренесид(дво а,дво б,дво в);//{ glTranslated(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глПеренеси(плав а,плав б,плав в);//{ glTranslatef(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}

    Гбул  глСписок_ли(бцел а);//{return cast(Гбул)  glIsList(а);}
    проц глУдалиСписки(бцел а,Гцразм б);//{ glDeleteLists(а, б);}
    бцел глГенСписки(Гцразм а);//{return  cast(бцел) glGenLists(а);}
    проц глНовСписок(бцел а,Гперечень б);//{ glNewList(а, cast(GLenum) б);}
    проц глКонецСписка();//{ glEndList();}
    проц глВызовиСписок(бцел а);//{ glCallList(а);}
    проц глВызовиСписки(Гцразм а,Гперечень б,ук в);//{ glCallLists(а, cast(GLenum) б, в);}
    проц глОваСписка(бцел а);//{ glListBase(а);}

    проц глНачни(Гперечень а);//{ glBegin(cast(GLenum) а);}
    проц глСтоп();//{ glEnd();}
    проц глВершинад(дво а,дво б);//{ glVertex2d(cast(GLdouble) а,cast(GLdouble)  б);}
    проц глВершина(плав а,плав б);//{ glVertex2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глВершина(цел а,цел б);//{ glVertex2i(а, б);}
    проц глВершина(крат а,крат б);//{ glVertex2s(а, б);}
    проц глВершинад(дво а,дво б,дво в);//{ glVertex3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глВершина(плав а,плав б,плав в);//{ glVertex3f(cast(GLfloat) а, cast(GLfloat) б, cast(GLfloat) в);}
    проц глВершина(цел а,цел б,цел в);//{ glVertex3i(а, б, в);}
    проц глВершина(крат а,крат б,крат в);//{ glVertex3s(а, б, в);}
    проц глВершинад(дво а,дво б,дво в,дво г);//{ glVertex4d;
    проц глВершина(плав а,плав б,плав в,плав г);//{ glVertex4f;
    проц глВершина(цел а,цел б,цел в,цел г);//{ glVertex4i(а, б, в, г);}
    проц глВершина(крат а,крат б,крат в,крат г);//{ glVertex4s(а, б, в, г);}
    проц глВершина2(дво* а);//{glVertex2dv(cast(GLdouble*) а);}
    проц глВершина2(плав* а);//{ glVertex2fv(cast(GLfloat*) а);}
    проц глВершина2(цел* а);//{ glVertex2iv(а);}
    проц глВершина2(крат* а);//{glVertex2sv(а);}
    проц глВершина3(дво* а);//{glVertex3dv(cast(GLdouble*) а);}
    проц глВершина3(плав* а);//{ glVertex3fv(cast(GLfloat*) а);}
    проц глВершина3(цел* а);//{ glVertex3iv(а);}
    проц глВершина3(крат* а);//{ glVertex3sv(а);}
    проц глВершина4(дво* а);//{ glVertex4dv(cast(GLdouble*) а);}
    проц глВершина4(плав* а);//{ glVertex4fv(cast(GLfloat*) а);}
    проц глВершина4(цел* а);//{ glVertex4iv(а);}
    проц глВершина4(крат* а);//{glVertex4sv(а);}
    проц глНормаль(байт а,байт б,байт в);//{ glNormal3b(а, б, в);}
    проц глНормальд(дво а,дво б,дво в);//{ glNormal3d(cast(GLdouble) а,cast(GLdouble)  б,cast(GLdouble)  в);}
    проц глНормаль(плав а,плав б,плав в);//{ glNormal3f(cast(GLfloat) а, cast(GLfloat) б,cast(GLfloat)  в);}
    проц глНормаль(цел а,цел б,цел в);//{ glNormal3i(а, б, в);}
    проц глНормаль(крат а,крат б,крат в);//{ glNormal3s(а, б, в);}
    проц глНормаль(байт* а);//{ glNormal3bv(а);}
    проц глНормаль(дво* а);//{ glNormal3dv(cast(GLdouble*) а);}
    проц глНормаль(плав* а);//{ glNormal3fv(cast(GLfloat*) а);}
    проц глНормаль(цел* а);//{glNormal3iv(а);}
    проц глНормаль(крат* а);//{ glNormal3sv(а);}
    проц глИндексд(дво а);//{ glIndexd(cast(GLdouble) а);}
    проц глИндекс(плав а);//{ glIndexf(cast(GLfloat) а);}
    проц глИндекс(цел а);//{ glIndexi(а);}
    проц глИндекс(крат а);//{ glIndexs(а);}
    проц глИндекс(ббайт а);//{ glIndexub(а);}
    проц глИндекс(дво* а);//{ glIndexdv(cast(GLdouble*) а);}
    проц глИндекс(плав* а);//{ glIndexfv(cast(GLfloat*) а);}
    проц глИндекс(цел* а);//{ glIndexiv(а);}
    проц глИндекс(крат* а);//{ glIndexsv(а);}
    проц глИндекс(ббайт* а);//{glIndexubv(а);}
    проц глЦвет(байт а,байт б,байт в);//{ glColor3b(а,б,в);}
    проц глЦветд(дво а,дво б,дво в);//{ glColor3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глЦвет(плав а,плав б,плав в);//{ glColor3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глЦвет(цел а,цел б,цел в);//{ glColor3i(а,б,в);}
    проц глЦвет(крат а,крат б,крат в);//{ glColor3s(а,б,в);}
    проц глЦвет(ббайт а,ббайт б,ббайт в);//{ glColor3ub(а,б,в);}
    проц глЦвет(бцел а,бцел б,бцел в);//{ glColor3ui(а,б,в);}
    проц глЦвет(бкрат а,бкрат б,бкрат в);//{ glColor3us(а,б,в);}
    проц глЦвет(байт а,байт б,байт в,байт г);//{ glColor4b(а,б,в,г);}
    проц глЦветд(дво а,дво б,дво в,дво г);//{ glColor4d;
    проц глЦвет(плав а,плав б,плав в,плав г);//{ glColor4f;
    проц глЦвет(цел а,цел б,цел в,цел г);//{ glColor4i(а,б,в,г);}
    проц глЦвет(крат а,крат б,крат в,крат г);//{ glColor4s(а,б,в,г);}
    проц глЦвет(ббайт а,ббайт б,ббайт в,ббайт г);//{ glColor4ub(а,б,в,г);}
    проц глЦвет(бцел а,бцел б,бцел в,бцел г);//{ glColor4ui(а,б,в,г);}
    проц глЦвет(бкрат а,бкрат б,бкрат в,бкрат г);//{ glColor4us(а,б,в,г);}
    проц глЦвет3(байт* а);//{ glColor3bv(cast(GLbyte*) а);}
    проц глЦвет3(дво* а);//{ glColor3dv(cast(GLdouble*) а);}
    проц глЦвет3(плав* а);//{ glColor3fv(cast(GLfloat*) а);}
    проц глЦвет3(цел* а);//{glColor3iv(cast(GLint*) а);}
    проц глЦвет3(крат* а);//{ glColor3sv(cast(GLshort*) а);}
    проц глЦвет3(ббайт* а);//{ glColor3ubv(cast(GLubyte*) а);}
    проц глЦвет3(бцел* а);//{ glColor3uiv(cast(GLuint*) а);}
    проц глЦвет3(бкрат* а);//{ glColor3usv(cast(GLushort*) а);}
    проц глЦвет4(байт* а);//{ glColor4bv(cast(GLbyte*) а);}
    проц глЦвет4(дво* а);//{ glColor4dv(cast(GLdouble*) а);}
    проц глЦвет4(плав* а);//{ glColor4fv(cast(GLfloat*) а);}
    проц глЦвет4(цел* а);//{ glColor4iv(cast(GLint*) а);}
    проц глЦвет4(крат* а);//{ glColor4sv(cast(GLshort*) а);}
    проц глЦвет4(ббайт* а);//{glColor4ubv(cast(GLubyte*) а);}
    проц глЦвет4(бцел* а);//{ glColor4uiv(cast(GLuint*) а);}
    проц глЦвет4(бкрат а);//{ glColor4usv(cast(GLushort) а);}
    проц глКоордТексд(дво а);//{ glTexCoord1d(cast(GLdouble) а);}
    проц глКоордТекс(плав а);//{ glTexCoord1f(cast(GLfloat) а);}
    проц глКоордТекс(цел а);//{ glTexCoord1i(cast(GLint) а);}
    проц глКоордТекс(крат а);//{ glTexCoord1s(cast(GLshort) а);}
    проц глКоордТексд(дво а,дво б);//{ glTexCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глКоордТекс(плав а,плав б);//{ glTexCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глКоордТекс(цел а,цел б);//{ glTexCoord2i(cast(GLint) а,cast(GLint) б);}
    проц глКоордТекс(крат а,крат б);//{ glTexCoord2s(cast(GLshort) а,cast(GLshort) б);}
    проц глКоордТексд(дво а,дво б,дво в);//{ glTexCoord3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глКоордТекс(плав а,плав б,плав в);//{ glTexCoord3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глКоордТекс(цел а,цел б,цел в);//{ glTexCoord3i(cast(GLint) а,cast(GLint) б,cast(GLint) в);}
    проц глКоордТекс(крат а,крат б,крат в);//{ glTexCoord3s(cast(GLshort) а,cast(GLshort) б,cast(GLshort) в);}
    проц глКоордТексд(дво а,дво б,дво в,дво г);//{ glTexCoord4d;
    проц глКоордТекс(плав а,плав б,плав в,плав г);//{ glTexCoord4f;
    проц глКоордТекс(цел а,цел б,цел в,цел г);//{ glTexCoord4i(а,б,в,г);}
    проц глКоордТекс(крат а,крат б,крат в,крат г);//{ glTexCoord4s(а,б,в,г);}
    проц глКоордТекс1(дво* а);//{glTexCoord1dv(cast(GLdouble*) а);}
    проц глКоордТекс1(плав* а);//{ glTexCoord1fv(cast(GLfloat*) а);}
    проц глКоордТекс1(цел* а);//{ glTexCoord1iv(а);}
    проц глКоордТекс1(крат* а);//{ glTexCoord1sv(а);}
    проц глКоордТекс2(дво* а);//{ glTexCoord2dv(cast(GLdouble*) а);}
    проц глКоордТекс2(плав* а);//{ glTexCoord2fv(cast(GLfloat*) а);}
    проц глКоордТекс2(цел* а);//{ glTexCoord2iv(а);}
    проц глКоордТекс2(крат* а);//{ glTexCoord2sv(а);}
    проц глКоордТекс3(дво* а);//{ glTexCoord3dv(cast(GLdouble*) а);}
    проц глКоордТекс3(плав* а);//{ glTexCoord3fv(cast(GLfloat*) а);}
    проц глКоордТекс3(цел* а);//{ glTexCoord3iv(а);}
    проц глКоордТекс3(крат* а);//{glTexCoord3sv(а);}
    проц глКоордТекс4(дво* а);//{ glTexCoord4dv(cast(GLdouble*) а);}
    проц глКоордТекс4(плав* а);//{glTexCoord4fv(cast(GLfloat*) а);}
    проц глКоордТекс4(цел* а);//{ glTexCoord4iv(а);}
    проц глКоордТекс4(крат* а);//{glTexCoord4sv(а);}
    проц глПозРастрад(дво а,дво б);//{ glRasterPos2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глПозРастра(плав а,плав б);//{ glRasterPos2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глПозРастра(цел а,цел б);//{ glRasterPos2i(а,б);}
    проц глПозРастра(крат а,крат б);//{ glRasterPos2s(а,б);}
    проц глПозРастрад(дво а,дво б,дво в);//{ glRasterPos3d(cast(GLdouble) а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глПозРастра(плав а,плав б,плав в);//{ glRasterPos3f(cast(GLfloat) а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глПозРастра(цел а,цел б,цел в);//{ glRasterPos3i(а,б,в);}
    проц глПозРастра(крат а,крат б,крат в);//{ glRasterPos3s(а,б,в);}
    проц глПозРастрад(дво а,дво б,дво в,дво г);//{ glRasterPos4d;
    проц глПозРастра(плав а,плав б,плав в,плав г);//{ glRasterPos4f;
    проц глПозРастра(цел а,цел б,цел в,цел г);//{ glRasterPos4i(а,б,в,г);}
    проц глПозРастра(крат а,крат б,крат в,крат г);//{ glRasterPos4s(а,б,в,г);}
    проц глПозРастра2(дво* а);//{glRasterPos2dv(cast(GLdouble*) а);}
    проц глПозРастра2(плав* а);//{ glRasterPos2fv(cast(GLfloat*) а);}
    проц глПозРастра2(цел* а);//{glRasterPos2iv(а);}
    проц глПозРастра2(крат* а);//{ glRasterPos2sv(а);}
    проц глПозРастра3(дво* а);//{ glRasterPos3dv(cast(GLdouble*) а);}
    проц глПозРастра3(плав* а);//{ glRasterPos3fv(cast(GLfloat*) а);}
    проц глПозРастра3(цел* а);//{ glRasterPos3iv(а);}
    проц глПозРастра3(крат* а);//{glRasterPos3sv(а);}
    проц глПозРастра4(дво* а);//{ glRasterPos4dv(cast(GLdouble*) а);}
    проц глПозРастра4(плав* а);//{ glRasterPos4fv(cast(GLfloat*) а);}
    проц глПозРастра4(цел* а);//{ glRasterPos4iv(а);}
    проц глПозРастра4(крат* а);//{glRasterPos4sv(а);}
    проц глПрямоугд(дво а,дво б,дво в,дво г);//{ glRectd;
    проц глПрямоуг(плав а,плав б,плав в,плав г);//{ glRectf;
    проц глПрямоуг(цел а,цел б,цел в,цел г);//{ glRecti(cast(GLint) а,cast(GLint) б,cast(GLint) в,cast(GLint) г);}
    проц глПрямоуг(крат а,крат б,крат в,крат г);//{ glRects;
    проц глПрямоуг(дво* а);//{glRectdv(cast(GLdouble*) а);}
    проц глПрямоуг(плав* а);//{glRectfv(cast(GLfloat*) а);}
    проц глПрямоуг(цел* а);//{glRectiv(cast(GLint*) а);}
    проц глПрямоуг(крат* а);//{ glRectsv(cast(GLshort*)а);}

    проц глМодельТени(Гперечень а);//{ glShadeModel(cast(GLenum) а);}
    проц глСвет(Гперечень а,Гперечень б,плав в);//{ glLightf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глСвет(Гперечень а,Гперечень б,цел в);//{ glLighti(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    проц глСвет(Гперечень а,Гперечень б,плав* в);//{ glLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глСвет(Гперечень а,Гперечень б,цел* в);//{ glLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайСвет(Гперечень а,Гперечень б,плав* в);//{glGetLightfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайСвет(Гперечень а,Гперечень б,цел* в);//{ glGetLightiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глМодельСвета(Гперечень а,плав б);//{ glLightModelf(cast(GLenum) а,cast(GLfloat) б);}
    проц глМодельСвета(Гперечень а,цел б);//{ glLightModeli(cast(GLenum) а,cast(GLint) б);}
    проц глМодельСвета(Гперечень а,плав* б);//{ glLightModelfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глМодельСвета(Гперечень а,цел* б);//{glLightModeliv(cast(GLenum) а,cast(GLint*) б);}
    проц глМатериал(Гперечень а,Гперечень б,плав в);//{ glMaterialf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глМатериал(Гперечень а,Гперечень б,цел в);//{ glMateriali(cast(GLenum) а,cast(GLenum) б,cast(GLint) в);}
    проц глМатериал(Гперечень а,Гперечень б,плав* в);//{ glMaterialfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глМатериал(Гперечень а,Гперечень б,цел* в);//{ glMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глДайМатериал(Гперечень а,Гперечень б,плав* в);//{ glGetMaterialfv;
    проц глДайМатериал(Гперечень а,Гперечень б,цел* в);//{ glGetMaterialiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глМатериалЦвета(Гперечень а,Гперечень б);//{ glColorMaterial(cast(GLenum) а,cast(GLenum) б);}
	
    проц глЗумПикселя(плав а,плав б);//{ glPixelZoom(cast(GLfloat) а, cast(GLfloat) б);}
    проц глСохраниПиксель(Гперечень а,плав б);//{ glPixelStoref(cast(GLenum) а,cast(GLfloat) б);}
    проц глСохраниПиксель(Гперечень а,цел б);//{ glPixelStorei(cast(GLenum) а,cast(GLint) б);}
    проц глПереместиПиксель(Гперечень а,плав б);//{ glPixelTransferf(cast(GLenum) а,cast(GLfloat) б);}
    проц глПереместиПиксель(Гперечень а,цел б);//{ glPixelTransferi(cast(GLenum) а,cast(GLint) б);}
    проц глКартируйПиксель(Гперечень а,цел б,плав* в);//{ glPixelMapfv(cast(GLenum) а,cast(GLint) б,cast(GLfloat*) в);}
    проц глКартируйПиксель(Гперечень а,цел б,бцел* в);//{ glPixelMapuiv(cast(GLenum) а,cast(GLint) б,в);}
    проц глКартируйПиксель(Гперечень а,цел б,бкрат* в);//{ glPixelMapusv(cast(GLenum) а,cast(GLint) б,в);}
    проц глДайКартуПикселя(Гперечень а,плав* б);//{ glGetPixelMapfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глДайКартуПикселя(Гперечень а,бцел* б);//{ glGetPixelMapuiv(cast(GLenum) а,б);}
    проц глДайКартуПикселя(Гперечень а,бкрат* б);//{ glGetPixelMapusv(cast(GLenum) а,б);}
    проц глБитмап(Гцразм а,Гцразм б,плав в,плав г,плав д,плав е,ббайт* ё);//{ glBitmap;
    проц глЧитайПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д,Гперечень е,ук ё);//{glReadPixels;
    проц глРисуйПиксели(Гцразм а,Гцразм б,Гперечень в,Гперечень г,ук д);//{ glDrawPixels;
    проц глКопируйПиксели(цел а,цел б,Гцразм в,Гцразм г,Гперечень д);//{ glCopyPixels;

    проц глФункцШаблона(Гперечень а,цел б,бцел в);//{ glStencilFunc(cast(GLenum) а,cast(GLint) б,cast(GLuint) в);}
    проц глМаскаШаблона(бцел а);//{ glStencilMask(cast(GLuint) а);}
    проц глОпШаблона(Гперечень а,Гперечень б,Гперечень в);//{ glStencilOp(cast(GLenum) а,cast(GLenum) б,cast(GLenum) в);}
    проц глОчистиШаблон(цел а);//{ glClearStencil(cast(GLint) а);}

    проц глГенТекс(Гперечень а,Гперечень б,дво в);//{ glTexGend(cast(GLenum) а,cast(GLenum) б,cast(GLdouble) в);}
    проц глГенТекс(Гперечень а,Гперечень б,плав в);//{ glTexGenf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глГенТекс(Гперечень а,Гперечень б,цел в);//{ glTexGeni(cast(GLenum) а,cast(GLenum) б,в);}
    проц глГенТекс(Гперечень а,Гперечень б,дво* в);//{ glTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глГенТекс(Гперечень а,Гперечень б,плав* в);//{ glTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глГенТекс(Гперечень а,Гперечень б,цел* в);//{ glTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,дво* в);//{ glGetTexGendv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,плав* в);//{ glGetTexGenfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайГенТекс(Гперечень а,Гперечень б,цел* в);//{ glGetTexGeniv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глСредаТекс(Гперечень а,Гперечень б,плав в);//{ glTexEnvf(cast(GLenum) а,cast(GLenum) б,cast(GLfloat) в);}
    проц глСредаТекс(Гперечень а,Гперечень б,цел в);//{ glTexEnvi(cast(GLenum) а,cast(GLenum) б,в);}
    проц глСредаТекс(Гперечень а,Гперечень б,плав* в);//{ glTexEnvfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глСредаТекс(Гперечень а,Гперечень б,цел* в);//{ glTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глДайСредуТекс(Гперечень а,Гперечень б,плав* в);//{ glGetTexEnvfv;
    проц глДайСредуТекс(Гперечень а,Гперечень б,цел* в);//{ glGetTexEnviv(cast(GLenum) а,cast(GLenum) б,в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,плав в);//{ glTexParameterf;
    проц глПараметрТекс(Гперечень а,Гперечень б,цел в);//{ glTexParameteri(cast(GLenum) а,cast(GLenum) б,в);}
    проц глПараметрТекс(Гперечень а,Гперечень б,плав* в);//{ glTexParameterfv;
    проц глПараметрТекс(Гперечень а,Гперечень б,цел* в);//{ glTexParameteriv;
    проц глДайПараметрТекс(Гперечень а,Гперечень б,плав* в);//{glGetTexParameterfv;
    проц глДайПараметрТекс(Гперечень а,Гперечень б,цел* в);//{glGetTexParameteriv;
    проц глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,плав* г);//{ glGetTexLevelParameterfv;
    проц глДайПараметрУровняТекс(Гперечень а,цел б,Гперечень в,цел* г);//{ glGetTexLevelParameteriv(cast(GLenum) а,б,в,г);}
    проц глОбразТекст1М(Гперечень а,цел б,цел в,Гцразм г,цел д,Гперечень е,Гперечень ё,ук ж);//{ glTexImage1D;
    проц глОбразТекс2М(Гперечень а,цел б,цел в,Гцразм г,Гцразм д,цел е,Гперечень ё,Гперечень ж,ук з);//{glTexImage2D;
    проц глДайОбразТекс(Гперечень а,цел б,Гперечень в,Гперечень г,ук д);//{ glGetTexImage;
    проц глКарта1(Гперечень а,дво б,дво в,цел  г,цел д,дво* е);//{ glMap1d;
    проц глКарта1(Гперечень а,плав б,плав в,цел г,цел д,плав* е);//{ glMap1f;
    проц глКарта2(Гперечень а,дво б,дво в,цел г,цел д,дво е,дво ё,цел ж,цел з,дво* и);//{glMap2d;
    проц глКарта2(Гперечень а,плав б,плав в,цел г,цел д,плав е,плав ё,цел ж,цел з,плав* и);//{glMap2f;
    проц глДайКарту(Гперечень а,Гперечень б,дво* в);//{ glGetMapdv(cast(GLenum) а,cast(GLenum) б,cast(GLdouble*) в);}
    проц глДайКарту(Гперечень а,Гперечень б,плав* в);//{ glGetMapfv(cast(GLenum) а,cast(GLenum) б,cast(GLfloat*) в);}
    проц глДайКарту(Гперечень а,Гперечень б,цел* в);//{ glGetMapiv(cast(GLenum) а,cast(GLenum) б,cast(GLint*) в);}
    проц глОцениКоорд1(дво а);//{ glEvalCoord1d(cast(GLdouble) а);}
    проц глОцениКоорд1(плав а);//{ glEvalCoord1f(cast(GLfloat) а);}
    проц глОцениКоорд1(дво* а);//{ glEvalCoord1dv(cast(GLdouble*) а);}
    проц глОцениКоорд1(плав* а);//{ glEvalCoord1fv(cast(GLfloat*) а);}
    проц глОцениКоорд2(дво а,дво б);//{ glEvalCoord2d(cast(GLdouble) а,cast(GLdouble) б);}
    проц глОцениКоорд2(плав а,плав б);//{ glEvalCoord2f(cast(GLfloat) а,cast(GLfloat) б);}
    проц глОцениКоорд2(дво* а);//{ glEvalCoord2dv(cast(GLdouble*) а);}
    проц глОцениКоорд2(плав* а);//{ glEvalCoord2fv(cast(GLfloat*) а);}
    проц глСеткаКарты1(цел а,дво б,дво в);//{ glMapGrid1d(а,cast(GLdouble) б,cast(GLdouble) в);}
    проц глСеткаКарты1(цел а,плав б,плав в);//{ glMapGrid1f(а,cast(GLfloat) б,cast(GLfloat) в);}
    проц глСеткаКарты2(цел а,дво б,дво в,цел г,дво д,дво е);//{ glMapGrid2d;
    проц глСеткаКарты2(цел а,плав б,плав в,цел г,плав д,плав е);//{ glMapGrid2f;
    проц глОцениТочку1(цел а);//{ glEvalPoint1(cast(GLint) а);}
    проц глОцениТочку2(цел а,цел б);//{ glEvalPoint2(cast(GLint) а,cast(GLint) б);}
    проц глОцениМеш1(Гперечень а,цел б,цел в);//{ glEvalMesh1(cast(GLenum) а,cast(GLint) б,cast(GLint) в);}
    проц глОцениМеш2(Гперечень а,цел б,цел в,цел г,цел д);//{ glEvalMesh2;

    проц глТуман(Гперечень а,плав б);//{ glFogf(cast(GLenum) а,cast(GLfloat) б);}
    проц глТуман(Гперечень а,цел б);//{ glFogi(cast(GLenum) а,cast(GLint) б);}
    проц глТуман(Гперечень а,плав* б);//{ glFogfv(cast(GLenum) а,cast(GLfloat*) б);}
    проц глТуман(Гперечень а,цел* б);//{ glFogiv(cast(GLenum) а,cast(GLint*) б);}

   проц глБуферФидбэка(Гцразм а,Гперечень б,плав* в);//{ glFeedbackBuffer;
    проц глПропуск(плав а);//{ glPassThrough(cast(GLfloat) а);}
    проц глВыбериБуфер(Гцразм а,бцел* б);//{ glSelectBuffer(cast(GLsizei) а,cast(GLuint*) б);}
    проц глИницИмена();//{ glInitNames();}
    проц глЗагрузиИмя(бцел а);//{ glLoadName(cast(GLuint) а);}
    проц глСуньИмя(бцел а);//{ glPushName(cast(GLuint) а);}
    проц глВыньИмя();//{ glPopName();}

    проц глГенТекстуры(Гцразм а,бцел* б);//{ glGenTextures(cast(GLsizei)а,cast(GLuint*) б);}
    проц глУдалиТекстуры(Гцразм а,бцел* б);//{ glDeleteTextures(cast(GLsizei)а,cast(GLuint*) б);}
    проц глПривяжиТекстуру(Гперечень а,бцел б);//{ glBindTexture(cast(GLenum) а,cast(GLuint) б);}
    проц глПриоритетТекстурам(Гцразм а,бцел* б,Гклампп* в);//{ glPrioritizeTextures(cast(GLsizei)а,cast(GLuint*) б,в);}
    Гбул  глРезидентныТекстуры_ли(Гцразм а,бцел* б,Гбул* в);//{return cast(Гбул) glAreTexturesResident;
    Гбул  глТекстура_ли(бцел а);//{ return cast(Гбул) glIsTexture(а);}

    проц глПодобразТекст1М(Гперечень а,цел б,цел в,Гцразм г,
	                   Гперечень д,Гперечень е,ук ё);//{ glTexSubImage1D;
    проц глПодобразТекс2М(Гперечень а,цел б,цел в,цел г,
	                  Гцразм д,Гцразм е,Гперечень ё,Гперечень ж,ук з);//{ glTexSubImage2D;
    проц глКопируйОбразТекс1М(Гперечень а,цел б,
	                  Гперечень в,цел г,цел д,Гцразм е,цел ё);//{ glCopyTexImage1D;
    проц глКопируйОбразТекст2М(Гперечень а,цел б,
	                  Гперечень в,цел г,цел д,Гцразм е,Гцразм ё,цел ж);//{ glCopyTexImage2D;
    проц глКопируйПодобразТекс1М(Гперечень а,цел б,цел в,цел г,цел д,Гцразм е);//{ glCopyTexSubImage1D;
    проц глКопируйПодобразТекс2М(Гперечень а,цел б,цел в,цел г,цел д,
	                  цел е,Гцразм ё,Гцразм ж);//{ glCopyTexSubImage2D;

    проц глУкНаВершину(цел а,Гперечень б,Гцразм в, ук г);//{ glVertexPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаНормаль(Гперечень а,Гцразм б,ук в);//{ glNormalPointer(а,cast(GLsizei) б,в);}
    проц глУкНаЦвет(цел а,Гперечень б,Гцразм в,ук г);//{ glColorPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаИндекс(Гперечень а,Гцразм б,ук в);//{ glIndexPointer(а,cast(GLsizei) б,в);}
    проц глУкНаКоордТекс(цел а,Гперечень б,Гцразм в,ук г);//{ glTexCoordPointer(а,б,cast(GLsizei) в,г);}
    проц глУкНаФлагКрая(Гцразм а,ук б);//{ glEdgeFlagPointer(cast(GLsizei) а,б);}
    проц глДайУк(Гперечень а,ук* б);//{ glGetPointerv(а,б);}
    проц глЭлементМассива(цел а);//{ glArrayElement(а);}
    проц глРисуйМассивы(Гперечень а,цел б,Гцразм в);//{ glDrawArrays(а,б,cast(GLsizei) в);}
    проц глРисуйЭлементы(Гперечень а,Гцразм б,Гперечень в,ук г);//{ glDrawElements(а,cast(GLsizei) б,в,г);}
    проц глСовместныеМассивы(Гперечень а,Гцразм б,ук в);//{ glInterleavedArrays(а,cast(GLsizei) б,в);}
	
/////glut
	
 проц глутИниц(цел* а= пусто, ткст0* б = пусто);//{ glutInit( а,  б);}
 проц глутИницПозОкна(цел а, цел б);//{ glutInitWindowPosition( а, б);}
 проц глутИницРазмерОкна(цел а, цел б);//{ glutInitWindowSize( а, б);}
 проц глутИницРежимПоказа(бцел режим);//{glutInitDisplayMode( режим);}
 проц глутИницТекстОкна(ткст0 а);//{glutInitDisplayString( а);}
 проц глутГлавныйЦикл();//{glutMainLoop();}
 цел глутСоздайОкно(ткст0 а);//{return cast(цел) glutCreateWindow( а);}
 цел глутСоздайПодокно(цел а, цел б, цел в, цел г, цел д);//{return cast(цел) glutCreateSubWindow(а,  б,  в,  г,  д);}
 проц глутРазрушьОкно(цел а);//{glutDestroyWindow( а);}
 проц глутФункцПоказа(дфунк а);//{glutDisplayFunc( а);}
 ///////////////
 проц глутУстановиОкно(цел а);//{ glutSetWindow( а);}
 цел глутДайОкно();//{return cast(цел) glutGetWindow();}
 проц глутУстановиЗагОкна(ткст0 заг);//{ glutSetWindowTitle( заг);}
 проц глутУстановиЗагПикт(ткст0 заг);//{ glutSetIconTitle( заг);}
 проц глутПерерисуйОкно(цел а, цел б);//{ glutReshapeWindow( а,  б);}
 проц глутПоместиОкно(цел а, цел б);//{ glutPositionWindow( а, б);}
 проц глутПокажиОкно();//{ glutShowWindow();}
 проц глутСпрячьОкно();//{ glutHideWindow();}
 проц глутСверниОкно();//{ glutIconifyWindow();}
 проц глутСуньОкно();//{ glutPushWindow();}
 проц глутВыньОкно();//{ glutPopWindow();}
 проц глутПолныйЭкран();//{ glutFullScreen();}
 проц глутПерепоказОкна(цел а);//{ glutPostWindowRedisplay(а);}
 проц глутПерепоказ();//{ glutPostRedisplay();}
 проц глутОбменБуферов();//{ glutSwapBuffers();}
 проц глутУкНаВарп(цел а, цел б);//{ glutWarpPointer(а, б);}
 проц глутУстановиКурсор(цел а);//{glutSetCursor(а);}
 проц глутУстановиНакладку();//{ glutEstablishOverlay();}
 проц глутУдалиНакладку();//{ glutRemoveOverlay();}
 проц глутИспользуйСлой(Гперечень а);//{glutUseLayer(cast(GLenum) а);}
 проц глутПерепоказНакладки();//{ glutPostOverlayRedisplay();}
 проц глутПерепоказНакладкиОкна(цел а);//{glutPostWindowOverlayRedisplay(а);}
 проц глутПокажиНакладку();//{glutShowOverlay();}
 проц глутСкройНакладку();//{glutHideOverlay();}
 цел глутСоздайМеню(дфунк_Ц а);//{return  glutCreateMenu(а);}
 проц глутРазрушьМеню(цел а);//{glutDestroyMenu(а);}
 цел глутДайМеню();//{return glutGetMenu();}
 проц глутУстановиМеню(цел а);//{ glutSetMenu(а);}
 проц глутДобавьЗаписьМеню(ткст0 а, цел б);//{ glutAddMenuEntry(а, б);}
 проц глутДобавьПодменю(ткст0 а, цел б);//{ glutAddSubMenu(а,б);}
 проц глутПерейдиВЗаписьМеню(цел а, ткст0 б, цел в);//{ glutChangeToMenuEntry(а,б,в);}
 проц глутПерейдиВПодменю(цел а, ткст0 б, цел в);//{ glutChangeToSubMenu(а,б,в);}
 проц глутУдалиЭлементМеню(цел а);//{glutRemoveMenuItem(а);}
 проц глутПрикрепиМеню(цел а);//{glutAttachMenu(а);}
 проц глутОткрепиМеню(цел а);//{ glutDetachMenu(а);}
 проц глутФункцТаймера(цел а, дфунк_Ц б, цел в);//{glutTimerFunc(а,б,в);}
 проц глутФункцБездействия(дфунк а);//{ glutIdleFunc(а);}
 проц глутФункцКлавиатуры(дфунк_СЦЦ а);//{glutKeyboardFunc(cast(KB_callback)а);}
 проц глутОсобаяФункция(дфунк_ЦЦЦ а);//{ glutSpecialFunc(а);}
 проц глутФункцПерерисовки(дфунк_ЦЦ а);//{ glutReshapeFunc(а);}
 проц глутФункцВидимости(дфунк_Ц а);//{glutVisibilityFunc(а);}
 проц глутФункцМыши(дфунк_ЦЦЦЦ а);//{ glutMouseFunc(а);}
 проц глутФункцДвижения(дфунк_ЦЦ а);//{ glutMotionFunc(а);}
 проц глутФункцияПассивногоДвижения(дфунк_ЦЦ а);//{ glutPassiveMotionFunc(а);}
 проц глутФункцияВвода(дфунк_Ц а);//{glutEntryFunc(а);}
 проц глутФункцОтжатияКлавиши(дфунк_бБЦЦ а);//{ glutKeyboardUpFunc(а);}
 проц глутОсобаяФункцОтжатия(дфунк_СЦЦ а);//{glutSpecialUpFunc(cast(KB_callback) а);}
 проц глутФункцДжойстика(дфунк_бЦЦЦЦ а, цел б);//{ glutJoystickFunc(а,б);}
 проц глутФункцСостоянияМеню(дфунк_Ц а);//{glutMenuStateFunc(а);}
 проц глутФункцСтатусаМеню(дфунк_ЦЦЦ а);//{ glutMenuStatusFunc(а);}
 проц глутФункцПоказаНакладки(дфунк а);//{ glutOverlayDisplayFunc(cast(Display_callback)а);}
 проц глутФункцСтатусаОкна(дфунк_Ц а);//{ glutWindowStatusFunc(а);}
 проц глутФункцДвиженияНебесногоТела(дфунк_ЦЦЦ а);//{ glutSpaceballMotionFunc(а);}
 проц глутФункцВращенияНебесногоТела(дфунк_ЦЦЦ а);//{ glutSpaceballRotateFunc(а);}
 проц глутФункцКнопкаНебесногоТела(дфунк_ЦЦ а);//{ glutSpaceballButtonFunc(а);}
 проц глутФункцОкнаКнопки(дфунк_ЦЦ а);//{ glutButtonBoxFunc(а);}
 проц глутФункцАбонентов(дфунк_ЦЦ а);//{ glutDialsFunc(а);}
 проц глутФункцДвиженияТаблет(дфунк_ЦЦ а);//{glutTabletMotionFunc(а);}
 проц глутФункцКнопкиТаблет(дфунк_ЦЦЦЦ а);//{ glutTabletButtonFunc(а);}
 цел глутДай(Гперечень а);//{return  cast(цел) glutGet(а);} 
 цел глутДайУстройство(Гперечень а);//{return  cast(цел) glutDeviceGet(cast(GLenum) а);}
 цел глутДайМодификаторы();//{return cast(цел) glutGetModifiers();}
 цел глутДайСлой(Гперечень а);//{return cast(цел) glutLayerGet(а);}
 проц глутСимволБитмап(ук а, цел б);//{ glutBitmapCharacter(а, cast(GLint) б);}
 цел глутШиринаБитмап(ук а, цел б);//{return cast(цел) glutBitmapWidth(а,cast(GLint) б);}
 проц глутСимволШтриха(ук а, цел б);//{ glutStrokeCharacter(а,cast(GLint) б);}
 цел глутШиринаШтриха(ук а, цел б);//{return cast(цел) glutStrokeWidth(а,cast(GLint) б);}
 цел глутДлинаБитмап(ук а, ббайт* б);//{return cast(цел) glutBitmapLength( а, cast(GLubyte*) б);}
 цел глутДлинаШтриха(ук а, ббайт* б);//{return cast(цел)  glutStrokeLength(а, cast(GLubyte*) б);}
 проц глутКаркасныйКуб(дво а);//{ glutWireCube(cast(GLdouble) а);}
 проц глутПлотныйКуб(дво а);//{glutSolidCube(cast(GLdouble) а);}
 проц глутКаркаснаяСфера(дво а, цел б, цел в);//{ glutWireSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 проц глутПлотнаяСфера(дво а, цел б, цел в);//{glutSolidSphere(cast(GLdouble) а, cast(GLint) б, cast(GLint) в);}
 проц глутКаркасныйКонус(дво а, дво б, цел в, цел г);//{ glutWireCone;
 проц глутПлотныйКонус(дво а, дво б, цел в, цел г);//{ glutSolidCone;
 проц глутКаркасныйТор(дво а, дво б, цел в, цел г);//{ glutWireTorus;
 проц глутПлотныйТор(дво а, дво б, цел в, цел г);//{ glutSolidTorus;
 проц глутКаркасныйДодекаэдр();//{ glutWireDodecahedron();}
 проц глутПлотныйДодекаэдр();//{ glutSolidDodecahedron();}
 проц глутКаркасныйОктаэдр();//{ glutWireOctahedron();}
 проц глутПлотныйОктаэдр();//{ glutSolidOctahedron();}
 проц глутКаркасныйТетраэдр();//{ glutWireTetrahedron();}
 проц глутПлотныйТетраэдр();//{ glutSolidTetrahedron();}
 проц глутКаркасныйИкосаэдр();//{ glutWireIcosahedron();}
 проц глутПлотныйИкосаэдр();//{ glutSolidIcosahedron;
 проц глутКаркасныйЧайник(дво а);//{ glutWireTeapot;
 проц глутПлотныйЧайник(дво а);//{ glutSolidTeapot;
 проц глутТекстРежимаИгры(ткст0 а);//{glutGameModeString;
 цел глутВойдиВРежимИгры();//{return  glutEnterGameMode;
 проц глутПокиньРежимИгры();//{ glutLeaveGameMode;
 цел глутДайРежимИгры(Гперечень а);//{return  glutGameModeGet;
 цел глутДайПеремерВидео(Гперечень а);//{return  glutVideoResizeGet;
 проц глутУстановиПеремерВидео();//{ glutSetupVideoResizing;
 проц глутОстановиПеремерВидео();//{ glutStopVideoResizing;
 проц глутПеремерьВидео(цел а, цел б, цел в, цел г);//{ glutVideoResize;
 проц глутПанируйВидео(цел а, цел б, цел в, цел г);//glutVideoPan;
 проц глутУстановиЦвет(цел а, плав б, плав в, плав г);// glutSetColor;
 
 плав глутДайЦвет(цел а, цел б);//{return cast(плав) glutGetColor(cast(GLint) а, cast(GLint) б);}
 проц глутКопируйЦветокарту(цел а);//{ glutCopyColormap(cast(GLint) а);}
 проц глутИгнорируйПовторКлавиши(цел а);//{ glutIgnoreKeyRepeat(cast(GLint) а);}
 проц глутУстановиПовторКлавиши(цел а);//{glutSetKeyRepeat(cast(GLint) а);}
 проц глутФорсируйФункцДжойстика();//{ glutForceJoystickFunc();}
 цел глутПоддерживаемыеРасширения(ткст0 а);// glutExtensionSupported;
 проц глутОтчётОбОшибках();//{glutReportErrors();}
 
 //GLU
 
  проц  глуНачниКривую (Нурб* nurb);//{gluBeginCurve ;
 проц  глуНачниМногоуг (Тесс* tess);//gluBeginPolygon ;
 проц  глуНачниПоверхность (Нурб* nurb);//{gluBeginSurface (cast(GLUnurbs*) nurb);}
 проц  глуНачниОбрез (Нурб* nurb);//{gluBeginTrim (cast(GLUnurbs*) nurb);}
 
 цел  глуПострой1ММипмапы (Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип,  ук данные);// gluBuild1DMipmaps ;
 
 цел  глуПострой2ММипмапы (цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип,  ук данные);// gluBuild2DMipmaps ;
	
 version(MESA){
 цел глуПострой3МУровниМипмап(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные);// gluBuild3DMipmapLevels ;

 цел глуПострой3ММипмапы(Гперечень цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гцразм глубина, Гперечень формат, Гперечень тип,  ук данные);//  gluBuild3DMipmaps;
  
 Гбул глуПроверьРасширение(сим *имяРасш,  сим *ткстРасш);//  gluCheckExtension ;
 цел  глуПострой2МУровениМипмап (цел цель, цел внутрФормат, Гцразм ширина, Гцразм высота, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные);//gluBuild2DMipmapLevels ;
 
  цел  глуПострой1МУровниМипмап (Гперечень цель, цел внутрФормат, Гцразм ширина, Гперечень формат, Гперечень тип, цел уровень, цел ова, цел макс,  ук данные) ;//gluBuild1DMipmapLevels;
 }
 
 проц глуЦилиндр(Квадр* квад, дво ова, дво верх, дво высота, цел доли, цел пачки);// gluCylinder ;
	
 проц  глуУдалиОтобразительНурб(Нурб* nurb);//{gluDeleteNurbsRenderer (cast(GLUnurbs*) nurb);}
 проц  глуУдалиКвадр(Квадр *квад);//{gluDeleteQuadric (cast(GLUquadric*) квад);}
 проц  глуУдалиТесс(Тесс *тесс);//{gluDeleteTess (cast(GLUtesselator*) тесс);}
 
 проц  глуДиск(Квадр* квад, дво inner, дво внешний, цел доли, цел loops);//gluDisk;
	
 проц  глуКонКрив(Нурб* нурб);//{gluEndCurve (cast(GLUnurbs*) нурб);}
 проц  глуКонМногоуг(Тесс *тесс);//{gluEndPolygon (cast(GLUtesselator*) тесс);}
 проц  глуКонПоверхн(Нурб* нурб);//{gluEndSurface (cast(GLUnurbs*) нурб);}
 проц  глуКонОбрез(Нурб* нурб);//{gluEndTrim (cast(GLUnurbs*) нурб);} 
 сим *глуТкстОш(Гперечень ош);//{return cast(ткст0)  gluErrorString (cast(GLenum) ош);}
  //////
 проц  глуПерспектива(дво fovy, дво aspect, дво zNear, дво zFar);//gluPerspective ;
 проц  глуОрто2М(дво лев, дво прав, дво низ, дво верх);//gluOrtho2D ;
 
 ////////////////////
 проц  глуДайСвойствоНурб(Нурб* nurb, Гперечень property, плав* данные);//{gluGetNurbsProperty ;
 
 сим *глуДайТкст(Гперечень имя);//  gluGetString ;
 
 проц  глуДайСвойствоТесс(Тесс* тесс, Гперечень какой, дво* данные);//{gluGetTessProperty ;
 
 проц  глуЗагрузиМатрицыСемплинга(Нурб* нурб, плав* модель, плав* перспектива, цел *вид);//{gluLoadSamplingMatrices;
 
 проц  глуВидНа(дво глазШ, дво глазВ, дво глазД, дво центрШ, дво центрВ, дво центрД, дво верхШ, дво верхВ, дво верхД);//{gluLookAt;
 
 Нурб* глуНовыйОтобразительНурб();//{return cast(Нурб*)  gluNewNurbsRenderer ;
 
 Квадр* глуНовыйКвадрик();//{return cast(Квадр*)  gluNewQuadric ;
 
 Тесс* глуНовыйТесс();//{return cast(Тесс*)  gluNewTess ;
 
 проц  глуСледщКонтур(Тесс* тесс, Гперечень тип);//{gluNextContour ;
 
 проц  глуОбрвызовНурбс(Нурб* нурб, Гперечень какой, винфунк фов);//{ gluNurbsCallback ;
 
 version(MESA)
 {
 проц  глуДанныеОбрвызоваНурб(Нурб* нурб, ук пользДанн);//{gluNurbsCallbackData; 
 проц глуДанныеОбрвызоваНурбДОП(Нурб* нурб, ук пользДанн);//{ gluNurbsCallbackDataEXT;
 }
 
 проц  глуКриваяНурб(Нурб* нурб, цел члоуз, плав* узлы, цел страйд, плав* упрэлт, цел порядок, Гперечень тип);//{gluNurbsCurve;
 
 проц  глуСвойствоНурб(Нурб* нурб, Гперечень свойство, плав знач);//{gluNurbsProperty ;
 
 проц  глуПоверхностьНурб(Нурб* нурб, цел члоузс, плав* узлыс, цел члоузт, плав* узлыт, цел пролётс, цел пролётт, плав* упрэлт, цел спорядок, цел тпорядок, Гперечень тип);//{gluNurbsSurface ;
 
 проц  глуПолуДиск(Квадр* квад, дво внутр, дво наруж, цел доли, цел петли, дво старт, дво метла);//{gluPartialDisk ;
 
 ///////////////////////
 проц  глуПодбериМатрицу(дво ш, дво в, дво делШ, дво делВ, цел *вьюпорт);//gluPickMatrix ;
	
 цел глуПроекция(дво обШ, дво обВ, дво обД, дво* модель, дво* проекц, цел *вид, дво *окШ, дво *окВ, дво *окД);// gluProject;
	  
 /*
 проц  gluPwlCurve (cast(GLUnurbs*) нурб, cast(GLint) count, cast(GLfloat*) данные, cast(GLint) stride, cast(GLenum) тип);
 */
 
 проц  глуОбрвызовКвадра(Квадр* квад, Гперечень который, винфунк фов);//{gluQuadricCallback ;
 
 проц глуКвадрСтильРисования(Квадр* квад, Гперечень рис);// gluQuadricDrawStyle ;
 
 проц  глуКвадрНормали(Квадр* квад, Гперечень нормаль);//gluQuadricNormals ;
 
 проц  глуКвадрОриентация(Квадр* квад, Гперечень ориент);//{gluQuadricOrientation ;
 
 проц  глуКвадрТекстура(Квадр* квад, бул текстура);// gluQuadricTexture ;
 /*
 цел cast(GLint)  gluScaleImage (cast(GLenum) формат, GLsizei wIn, GLsizei hIn, cast(GLenum) typeIn,  ук dataIn, GLsizei wOut, GLsizei hOut, cast(GLenum) typeOut, GLvoid* dataOut);
 */
 
 проц  глуШар(Квадр* квад, дво радиус, цел доли, цел пачки);// gluSphere ;
 
 проц  глуТессНачниКонтур(Тесс* тесс);//gluTessBeginContour ;

 проц  глуТессНачниМногогран(Тесс* тесс, ук данные);//gluTessBeginPolygon ;
 
 проц  глуОбрвызовТесс(Тесс* тесс, Гперечень который, винфунк ов);//{gluTessCallback (cast(GLUtesselator*) тесс, cast(GLenum) который, ов);}
 
 проц  глуТессЗавершиКонтур(Тесс* тесс);//{gluTessEndContour (cast(GLUtesselator*) тесс);}
 
 проц  глуТессЗавершиМногогран(Тесс* тесс);//{gluTessEndPolygon (cast(GLUtesselator*) тесс);}
 
 проц  глуТессНормаль(Тесс* тесс, дво значШ, дво значВ, дво значД);//{gluTessNormal (cast(GLUtesselator*) тесс, cast(GLdouble) значШ, cast(GLdouble) значШ, cast(GLdouble) значД);}
 
 проц  глуТессСвойство(Тесс* тесс, Гперечень который, дво данные);//{gluTessProperty (cast(GLUtesselator*) тесс, cast(GLenum) который, cast(GLdouble) данные);}
 
 проц  глуТессВершина(Тесс* тесс, дво *положен, ук данные);//{gluTessVertex (cast(GLUtesselator*) тесс, cast(GLdouble*) положен, cast(GLvoid*) данные);}
 
 /*
 цел cast(GLint)  gluUnProject (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ);
 
 
 целcast(GLint)  gluUnProject4 (cast(GLdouble) winX, cast(GLdouble) winY, cast(GLdouble) winZ, cast(GLdouble) clipW,  cast(GLdouble) *model,  cast(GLdouble) *proj,  cast(GLint) *view, cast(GLdouble) nearVal, cast(GLdouble) farVal, cast(GLdouble)* objX, cast(GLdouble)* objY, cast(GLdouble)* objZ, cast(GLdouble)* objW);
 */
