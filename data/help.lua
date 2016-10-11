do local _ = {
helps = [[ ]],

help = [[یکی از دستورات زیر را وارد کنید

1.) /Shelp    [راهنما برای تنظیمات ربات در گروه]

2.) /Mhelp    [راهنما برای مدیریت کاربران گروه]

3.) /Lhelp    [راهنما برای دسترسی به لیست های مدیریتی]

4.) /Ahelp    [راهنمای عمومی]

<code>با وارد کردن هرکدام بخش مربوط به همان قسمت را مشاهده خواهید کرد</code>


●●●●● نکات در مورد ربات های یوبی↙️

°ربات در هر <b>5</b> ثانیه به دستور شما جواب میدهد

°°ربات به داشتن  <b>!یا/یا# </b> قبل از دستور حساس نیست

°°°ربات به کوچکی یا بزرگی حروف در هنگام دستور حساس نیست

°°°°با دستور <b>nerkh </b> قیمت بقیه ربات هارا مشاهده کنید


username ==> شناسه کاربری : <i>@username</i>
id ==> شناسه یا ID : کد های عددی که با دستور id قابل دریافت است 
reply ==> ریپلی بر روی پیام فرد 

هرگونه مشکل را با ما در میان بگذارید 
سازنده : @valtman
ارتباط با سازنده برای افراد ریپورت :@UBsupbot
کانال اطلاع رسانی : @UB_CH
 ]],
shelp = [[راهنما برای تنظیم ربات :

<b>settings </b>       مشاهده تنظیمات
<code>setname متن </code>
عوض کردن اسم روه
<b>setphoto </b>
عوض کردن عکس گروه
<code>setabout متن </code>
عوض کردن توضیحات
<b>setrules متن </b>
قانون گذاری
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

<b>cmuser lock|unlock </b>درصورت lock بودن ربات به کاربران عادی اسخ نمیدهد

<b>settings lock|unlock </b>تنظیمات سختگیرانه

<b>lock link </b>
<b>lock spam </b>
<b>lock flood </b>
<b>lock fa </b>
<b>lock en </b>
<b>lock tgservice </b>
<b>lock share </b>
<b>lock text </b>
<b>lock video </b>
<b>lock file </b>
<b>lock gif </b>
<b>lock fwd </b>
<b>lock bot </b>
<b>lock reply </b>
<b>lock tag </b>

حال برای رفع ممنوعیت هرکدام بجای <b>LOCK</b> از <b>UNLOCK</b> استفاده کنید
 
<code>link </code> لینک تبلیغات تلگرام
<code>spam </code> پیام های طولانی
<code>flood </code> پیام های مکرر
<code>fwd </code> فوروارد
<code>reply </code> ریپلی یا پاسخ
<code>teg </code> پیام های دارای تگ
<code>bot </code> ربات های api
<code>en </code> متن های انگلیسی
<code>fa </code> متن های فارسی
<code>sticker </code> استیکر ها
<code>tgservice </code> متن های تلگرام در هنگام ریمو یا ادد کردن یا لفت داد و...
<code>share </code> شیر کردن شماره
<code>photo </code> عکس
<code>text </code> چت یا متن
<code>video </code> فیلم
<code>file </code> فایل یا سند
<code>gif </code> گیف یا تصاویر متحرک
]],
mhelp = [[راهنما برای کنترل کاربران :

<b>setadmin [username|id|reply] </b>
ادمین کردن کاربران ⚠️‼️
<b>demoteadmin [username|id|reply] </b>
محروم از ادمینی گروه ⚠️‼️
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

●●●●●نکته :
⚠️‼️ بدین معناست که ربات باید سازنده گروه باشد

[username|id|reply]
این عبارت در کنار دستور های بالا بدین معناست که هم باشناسه کاربری یا با شناسه و یا با ریپلی روی فردی میتوانید دستور را اجرا کنید

]],
lhelp = [[راهنما برای لیست های کاربران و گروه :

<b>owners </b>
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

<b>clean modlist </b>
<b>clean ownerlist </b>
<b>clean banlist </b>
<b>clean mutelist </b>
<b>clean rules </b>
<b>clean about </b>
<b>clean deleted </b>
<b>clean bots </b>
<b>clean filterlist </b>

تعریف هر CLEAN :
<code>modlist </code> لیست مدیران
<code>ownerlist </code> لیست صاحبان فرعی
<code>banlist </code> لیست افراد محروم از گروه
<code>mutelist </code> لیست افراد سکوت شده
<code>deleted </code> افراد دیلیت اکانت شده
<code>bots </code> ربات های API
<code>rules </code> قوانین
<code>about </code> توضیحات
<code>filterlist </code> لیست کلمات ممنوع

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

<b>filter + کلمه </b>
ممنوع کردن یک کلمه خاص
]]
}
return _
end
