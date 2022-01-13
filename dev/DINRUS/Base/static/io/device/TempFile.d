module io.device.TempFile;

import Путь = io.Path;
import math.random.Kiss : Kiss;
import io.device.Device : Устройство;
import io.device.File;

/******************************************************************************
 *
 * Класс ВремФайл стремится предоставить безопасный способ создания и удаления
 * временных файлов. Класс ВремФайл автоматически закроет временные файлы,
 * когда этот объект разрушен, поэтому рекоментуется выполнить соответствующие
 * деструкции в масшnабе scope (exit).
 *
 * Временные файлы создаются в одном из нескольких стилей, во многом подобно
 * обычным файлам. Стили ВремФайл имеют следующие свойства:
 *
 * $(UL
 * $(LI $(B ОпцУдаления): this determines whether the файл should be destroyed
 * as soon as it is закрыт (transient,) or continue в_ persist even after the
 * application есть terminated (permanent.))
 * )
 *
 * Eventually, this will be expanded в_ give you greater control over the
 * temporary файл's свойства.
 *
 * For the typical use-case (creating a файл в_ temporarily сохрани данные too
 * large в_ fit преобр_в память,) the following is sufficient:
 *
 * -----
 *  {
 *      scope temp = new ВремФайл;
 *      
 *      // Use temp as a нормаль провод; it will be automatically закрыт when
 *      // it goes out of scope.
 *  }
 * -----
 *
 * $(B Important):
 * It is recommended that you $(I do not) use файлы создан by this class в_
 * сохрани sensitive information.  There are several known issues with the
 * текущ implementation that could allow an attacker в_ доступ the contents
 * of these temporary файлы.
 *
 * $(B Todo): Detail security свойства and guarantees.
 *
 ******************************************************************************/


extern(D) 
class ВремФайл : Файл
{

    /**************************************************************************
     * 
     * This enumeration is used в_ control whether the temporary файл should
     * persist after the ВремФайл объект есть been destroyed.
     *
     **************************************************************************/

    enum ОпцУдаления : ббайт
    {
        /**
         * The temporary файл should be destroyed along with the хозяин объект.
         */
        ВКорзину,
        /**
         * The temporary файл should persist after the объект есть been
         * destroyed.
         */
        Навсегда
    }

    /**************************************************************************
     * 
     * This structure is used в_ determine как the temporary файлы should be
     * opened and used.
     *
     **************************************************************************/
    align(1) struct СтильВремфл
    {
        //Visibility visibility;      ///
        ОпцУдаления удаление;        ///
        //Sensitivity sensitivity;    ///
        //Общ совместно;                ///
        //Кэш кэш;                ///
        ббайт попытки = 10;          ///
    }

    /**
     * СтильВремфл for creating a transient temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл ВКорзину = {ОпцУдаления.ВКорзину};
    /**
     * СтильВремфл for creating a permanent temporary файл that only the текущ
     * пользователь can доступ.
     */
    static const СтильВремфл Навсегда = {ОпцУдаления.Навсегда};


    ///
    this(СтильВремфл стиль = СтильВремфл.init);

    ///
    this(ткст префикс, СтильВремфл стиль = СтильВремфл.init);

    /**************************************************************************
     *
     * Указывает стиль, с которым создан этот ВремФайл.
     *
     **************************************************************************/
    СтильВремфл стильВремфл();

   
    override проц открепи();
}