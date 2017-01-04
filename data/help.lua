do local _ = {
helps = [[ ]],

help2 = [[یکی از دستورات زیر را وارد کنید

1.) /Shelp    [راهنما برای تنظیمات ربات در گروه]

2.) /Mhelp    [راهنما برای مدیریت کاربران گروه]

3.) /Lhelp    [راهنما برای دسترسی به لیست های مدیریتی]

4.) /Ahelp    [راهنمای عمومی]

5.) /Fhelp    [راهنمای سرگرمی و کاربردی]

<i>ممکن است بعضی از رباتها دستور FHELP نداشته باشد </i>

<code>با وارد کردن هرکدام بخش مربوط به همان قسمت را مشاهده خواهید کرد</code>

●●●●● نکات در مورد ربات های یوبی↙️

°ربات در هر <b>5</b> ثانیه به دستور شما جواب میدهد

°ربات به داشتن  <b>!یا/یا# </b> قبل از دستور حساس نیست

°ربات به کوچکی یا بزرگی حروف در هنگام دستور حساس نیست

°با دستور <b>nerkh </b> قیمت بقیه ربات هارا مشاهده کنید


username ==> شناسه کاربری : <i>@username</i>
id ==> شناسه یا ID : کد های عددی که با دستور id قابل دریافت است 
reply ==> ریپلی بر روی پیام فرد 

هرگونه مشکل را با ما در میان بگذارید 
سازنده : @valtman
ارتباط با سازنده برای افراد ریپورت : @UBsupportbot
کانال اطلاع رسانی : @UB_CH
 ]],
shelp = [[راهنما برای تنظیم ربات :
expire
مدت زمان باقی مانده از شارژ گروه
<b>settings </b>
 مشاهده تنظیمات
<code>setname متن </code>
عوض کردن اسم روه
<b>setphoto </b>
عوض کردن عکس گروه
<code>setabout متن </code>
عوض کردن توضیحات
<b>setrules متن </b>
قانون گذاری
<b>setwlc متن </b>
تنظیم متن خوش امدگویی دلخواه * [نکته]
<code>settype متن </code>
تایین مشخصات گروه
<b>setflood رقم </b>
محدودیت تعداد پیام های مکرر
<code>settimeflood رقم </code>
محدودیت زمان پیام های مکرر
<b>setwarn رقم</b>
محدودیت اخطار به کاربران
<code>در انتخاب این عدد دقت کنید که محدودیت اخطار و محدودیت خطا میباشد </code>

<code>wlc on|off </code> فعال یا غیر فعال کردن خوش امدگویی

<b>cmuser lock </b>درصورت lock بودن ربات به کاربران عادی اسخ نمیدهد

<b>settings lock </b>تنظیمات سختگیرانه 

<b>lock link </b> لینک تبلیغات تلگرام
<b>lock spam </b> پیام های طولانی
<b>lock flood </b> پیام های مکرر
<b>lock fa </b> متن های فارسی
<b>lock en </b> متن های انگلیسی
<b>lock join </b> افراد جوین دهنده
<b>lock tgservice </b> متن های تلگرام در هنگام ریمو یا ادد کردن یا لفت دادن و...
<b>lock share </b> شیر کردن مخاطبین
<b>lock sticker </b> استیکر
<b>lock unsup </b> پیامهای ناشناخته
<b>lock text </b> چت یا متن
<b>lock video </b> فیلم
<b>lock media </b> هرچی غیر از متن
<b>lock caption </b> پیام های عنوان دار
<b>lock file </b> فایل
<b>lock gif </b> گیف یا تصاویر متحرک
<b>lock photo </b> عکس
<b>lock web </b> وبسایت
<b>lock fwd </b> فوروارد
<b>lock bot </b>  ربات
<b>lock reply </b> ریپلی یا پاسخ
<b>lock tag </b> پیام های دارای تگ
<b>lock all </b> فعال کردن همه پاک کننده ها

حال برای غیرفعال کردن هرکدام بجای <b>LOCK</b> از <b>UNLOCK</b> استفاده کنید
 
**برای تنظیم خوش امدگویی دلخوام اگر هر یک کلمه های زیر را بکار ببرید ربات بصورت خودکار جایگذین انرا نمایش میدهد

<code>$name </code>       اسم فرد وارد شده
<code>$gname </code>      اسم گروه
<code>$uname </code>      نام کاربری فرد وارد شده
<code>$2name </code>      اسم فرد دعوت کننده
<code>$u2name </code>     یوزرنیم فرد دعوت کننده
<code>$rules </code>      قوانین گروه
<code>$about </code>      توضیحات گروه
]],
mhelp = [[راهنما برای کنترل کاربران :

<b>setowners [username|id|reply] </b>
اعطا مقام صاحب گروه<code>(صاحبان فرعی)</code>
<b>remowners [username|id|reply] </b>
عذل کردن صاحبان فرعی
<b>promote [username|id|reply] </b>
اعطا مقام مدیریت
<b>demote [username|id|reply] </b>
عذل مقام مدیریت
<b>mute [username|id|reply] </b>
سکوت دادن به کارب
<b>unmute [username|id|reply] </b>
خارج کردن کاربر از لیست سکوت
<b>kick [username|id|reply] </b>
ریمو کردن کاربران
<b>ban [username|id|reply] </b>
محروم کردن افراد از گروه
<b>unban [username|id|reply] </b>
رفع محرومیت افراد از گروه
<b>warn [username|id|reply] </b>
دادن اخطار به کاربر
<b>unwarn [username|id|reply] </b>
رفع یک اخطار از کاربر
<b>unwarnall [username|id|reply] </b>
رفع همه اخطارهای کاربر

[username|id|reply]
این عبارت در کنار دستور های بالا بدین معناست که هم باشناسه کاربری یا با شناسه و یا با ریپلی روی فردی میتوانید دستور را اجرا کنید

]],
lhelp = [[راهنما برای لیست های کاربران و گروه :

<b>ownerlist </b>
مشاهده صاحبان فرعی و اصلی
<b>modlist </b>
 شماهده مدیران
<b>admins </b>
مشاهده ادمین های
<b>bots </b>
مشاهده ربات های <i> API </i>
<b>who </b>
مشاهده کاربران
<b>kicked </b>
 مشاهده کاربران بلاک لیست
<b>mutelist </b>
لیست افراد سکوت شده
<b>filterlist </b>
لیست کلمات ممنوع
<b>banlist </b>
لیست افراد محروم از گروه

خالی کردن یا پاک کردن :::::

<b>clean modlist </b> لیست مدیران
<b>clean ownerlist </b> لیست صاحبان فرعی
<b>clean banlist </b> لیست افراد محروم از گروه

<b>clean mutelist </b> لیست افراد سکوت شده
<b>clean rules </b> قوانین 
<b>clean about </b> توضیحات
<b>clean deleted </b> افراد دیلیت اکانت شده
<b>clean bots </b> ربات های API
<b>clean filterlist </b> لیست کلمات ممنوع

]],
ahelp = [[راهنما عمومی :
<b>gpinfo </b>مشخصات گروه
<b>owner </b>مشاهده صاحب اصلی
<b>del </b><code>[reply] </code> پاک کردن پیام
<b>newlink </b>دریافت لینک جدید ⚠️‼️
<b>setlink </b>ثبت لینک در ربات
<b>link </b>دریافت لینک از ربات
<b>about </b>توضیحات گروه
<b>rules </b>قوانین گروه
<b>type </b> مشاهده مشخصات گروه
<b>all </b>دریافت کلیه مشخصات گروه
<b>id [username|id|reply]</b>دریافت شناسه⚠️
<b>id from [reply]</b>دریافت شناسه از روی فرووارد

<b>rmsg رقم </b>
پاک کردن تعداد پیام های دلخواه

<b>mute all رقم </b>
سکوت کردن گروه برای تایم دلخواه

<b>mute all </b> سکوت کردن داعمی گروه

<b>mute all متن رقم </b> 

<b>stats mute all </b>مشاهده مدت زمان باقی مانده از سکوت

<b>filter کلمه </b>
ممنوع کردن یک کلمه خاص
<b>unfilter کلمه </b>
از فیلتر خارج کردن یک کلمه
]],
fhelp = [[
<b>abjad </b>کلمه
ابجد یک کلمه
<b>aparat </b>کلمه
جستوجو در اپارات
<b>arz </b>
ارز روز
<b>arz </b>مقدار
محاسبه ارزی یک مقدار پول
<b>azan </b>نام شهر
اوقات شرعی یک شهر
<b>stickerpro </b>متن
استیکر نویسی
<b>imagepro </b>متن
عکس نویسی
<b>time </b>
نشان دادن زمان
<b>danestani </b>
دانستنی ها
<b>date </b>
نشان دادن تاریخ
<b>ترجمه </b>کلمه
ترجمه یک کلمه به انگلیسی
<b>email </b>ادرس ایمیل
مشخصات یک ایمیل
<b>fal </b>
گرفتن فال رندوم
<b>fin </b>جملات فینگلیش
تبدیل جملات فینگلیش به فارسی
<b>font </b>کلمه فارسی
نشان دادن انواع فونت های فارسی
<b>gifpro </b>
راهنمای استفاده از gifpro
<b>github </b>ادرس گیت
نشان دادن مشخصات یک گیت هاب
<b>joke </b>
نشان دادن یک جوک
<b>keep calm </b>جملات کپ کالم
<b>logo </b>ادرس سایت
نشان دادن لوگو یک سایت
<b>logo> </b>ادرس سایت
نشان دادن لوگو سیاه و سفید یک سایت
<b>love اسم اسم </b>
عکس نویسی لاو
<b>mean </b>کلمه
معنی یک کلمه
<b>mobile </b>
لیست اخرین موبایل ها
<b>music </b>اسم انگلیسی
جستوجو یک اهنگ
<b>news </b>
اخرین اخبار ها
<b>sport </b>
اخرین اخبار های ورزشی
<b>t2g </b>متن
گیف نویسی
<b>t2i </b>متن
عکس نویسی پیشترفته
<b>tr fa|en </b>کلمه
ترجمه انگلیسی یا فارسی یک کلمه
<b>voice </b>متن
تبدیل متن به ویس
<b>weather </b>اسم شهر
اب و هوای یک شهر
<b>webshot </b>ادرس سایت
وب شات از یک ادرس
<b>wiki </b>کلمه
جستجو یک کلمه در ویکی پدیا
<b>write </b>کلمه انگلیسی
انواع فونت های انگلیسی برای یک کلمه انگلیسی

]],
adminhelp = [[
add 
ثبت گروه در ربات
rem 
حذف گروه در ربات 
leave
مجبور کردن ربات به ترک گروه
addtest [1-5]
ثبت گروه برای ساعت مشخص جهت آزمایش ربات
remtest
حذف گروه آزمایشی

expire تعداد روز
گذاشتن تاریخ انقضا
delexpire
   حذف مدت زمان انقضا
expire
مدت زمان باقی مانده از شارژ گروه
setowner [username|id|reply]
مشخص کردن صاحب اصلی گروه
p r
ریلود کردن ربات
invite [username|reply]
دعوت افراد 
import link
جوین دادن ربات با لینک
facts 
گرفتن مشخصات ربات
join groupid
ادد کردن شما توسط ربات توسط ایدی گروه


ادمین گرامی تقاضا میشود پول حلال دربیاورید حتی اندک

]],
help = [[
<b>settings </b>       مشاهده تنظیمات
<code>setname متن </code>
عوض کردن اسم روه
<b>setphoto </b>
عوض کردن عکس گروه
<code>setabout متن </code>
عوض کردن توضیحات
<b>setrules متن </b>
قانون گذاری
<b>setwlc متن </b>
تنظیم متن خوش امدگویی دلخواه * [نکته]
<code>settype متن </code>
تایین مشخصات گروه
<b>setflood رقم </b>
محدودیت تعداد پیام های مکرر
<code>settimeflood رقم </code>
محدودیت زمان پیام های مکرر
<b>setwarn رقم</b>
محدودیت اخطار به کاربران
<code>در انتخاب این عدد دقت کنید که محدودیت اخطار و محدودیت خطا میباشد </code>

<code>wlc on|off </code> فعال یا غیر فعال کردن خوش امدگویی

<b>cmuser lock </b>درصورت lock بودن ربات به کاربران عادی اسخ نمیدهد

<b>settings lock </b>تنظیمات سختگیرانه 

<b>lock link </b> لینک تبلیغات تلگرام
<b>lock spam </b> پیام های طولانی
<b>lock flood </b> پیام های مکرر
<b>lock fa </b> متن های فارسی
<b>lock en </b> متن های انگلیسی
<b>lock join </b> افراد جوین دهنده
<b>lock tgservice </b> متن های تلگرام در هنگام ریمو یا ادد کردن یا لفت دادن و...
<b>lock share </b> شیر کردن مخاطبین
<b>lock sticker </b> استیکر
<b>lock unsup </b> پیامهای ناشناخته
<b>lock text </b> چت یا متن
<b>lock video </b> فیلم
<b>lock media </b> هرچی غیر از متن
<b>lock caption </b> پیام های عنوان دار
<b>lock file </b> فایل
<b>lock gif </b> گیف یا تصاویر متحرک
<b>lock photo </b> عکس
<b>lock fwd </b> فوروارد
<b>lock bot </b>  ربات
<b>lock web </b> وبسایت
<b>lock reply </b> ریپلی یا پاسخ
<b>lock tag </b> پیام های دارای تگ
<b>lock all </b> فعال کردن همه پاک کننده ها

حال برای غیرفعال کردن هرکدام بجای <b>LOCK</b> از <b>UNLOCK</b> استفاده کنید
 
**برای تنظیم خوش امدگویی دلخوام اگر هر یک کلمه های زیر را بکار ببرید ربات بصورت خودکار جایگذین انرا نمایش میدهد

<code>$name </code>       اسم فرد وارد شده
<code>$gname </code>      اسم گروه
<code>$uname </code>      نام کاربری فرد وارد شده
<code>$2name </code>      اسم فرد دعوت کننده
<code>$u2name </code>     یوزرنیم فرد دعوت کننده
<code>$rules </code>      قوانین گروه
<code>$about </code>      توضیحات گروه


<b>setowners [username|id|reply] </b>
اعطا مقام صاحب گروه<code>(صاحبان فرعی)</code>
<b>remowners [username|id|reply] </b>
عذل کردن صاحبان فرعی
<b>promote [username|id|reply] </b>
اعطا مقام مدیریت
<b>demote [username|id|reply] </b>
عذل مقام مدیریت
<b>mute [username|id|reply] </b>
سکوت دادن به کارب
<b>unmute [username|id|reply] </b>
خارج کردن کاربر از لیست سکوت
<b>kick [username|id|reply] </b>
ریمو کردن کاربران
<b>ban [username|id|reply] </b>
محروم کردن افراد از گروه
<b>unban [username|id|reply] </b>
رفع محرومیت افراد از گروه
<b>warn [username|id|reply] </b>
دادن اخطار به کاربر
<b>unwarn [username|id|reply] </b>
رفع یک اخطار از کاربر
<b>unwarnall [username|id|reply] </b>
رفع همه اخطارهای کاربر

[username|id|reply]
این عبارت در کنار دستور های بالا بدین معناست که هم باشناسه کاربری یا با شناسه و یا با ریپلی روی فردی میتوانید دستور را اجرا کنید


<b>ownerlist </b>
مشاهده صاحبان فرعی و اصلی
<b>modlist </b>
 شماهده مدیران
<b>admins </b>
مشاهده ادمین های
<b>bots </b>
مشاهده ربات های <i> API </i>
<b>who </b>
مشاهده کاربران
<b>kicked </b>
 مشاهده کاربران بلاک لیست
<b>mutelist </b>
لیست افراد سکوت شده
<b>filterlist </b>
لیست کلمات ممنوع
<b>banlist </b>
لیست افراد محروم از گروه

خالی کردن یا پاک کردن :::::

<b>clean modlist </b> لیست مدیران
<b>clean ownerlist </b> لیست صاحبان فرعی
<b>clean banlist </b> لیست افراد محروم از گروه

<b>clean mutelist </b> لیست افراد سکوت شده
<b>clean rules </b> قوانین 
<b>clean about </b> توضیحات
<b>clean deleted </b> افراد دیلیت اکانت شده
<b>clean bots </b> ربات های API
<b>clean filterlist </b> لیست کلمات ممنوع

<b>gpinfo </b>مشخصات گروه
<b>owner </b>مشاهده صاحب اصلی
<b>del </b><code>[reply] </code> پاک کردن پیام
<b>newlink </b>دریافت لینک جدید ⚠️‼️
<b>setlink </b>ثبت لینک در ربات
<b>link </b>دریافت لینک از ربات
<b>about </b>توضیحات گروه
<b>rules </b>قوانین گروه
<b>type </b> مشاهده مشخصات گروه
<b>all </b>دریافت کلیه مشخصات گروه
<b>id [username|id|reply]</b>دریافت شناسه⚠️
<b>id from [reply]</b>دریافت شناسه از روی فرووارد

<b>rmsg رقم </b>
پاک کردن تعداد پیام های دلخواه

<b>mute all رقم </b>
سکوت کردن گروه برای تایم دلخواه

<b>mute all </b> سکوت کردن داعمی گروه

<b>mute all متن رقم </b> 

<b>stats mute all </b>مشاهده مدت زمان باقی مانده از سکوت

<b>filter کلمه </b>
ممنوع کردن یک کلمه خاص
<b>unfilter کلمه </b>
از فیلتر خارج کردن یک کلمه

]]
}
return _
end
