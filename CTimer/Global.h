//
//  Global.h
//  CoreTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#ifndef CTimer_Global_h
#define CTimer_Global_h

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define MAIN_FILE_NAME                    @"CTimer"
#define DEFAULT_TIMER_VALUE               1

//********************************* Color Constants. ****************************************

#define MAIN_TEXT_COLOR                   [UIColor colorWithRed: 116.0/255.0 green: 110.0/255.0 blue: 116.0/255.0 alpha:1.0]
#define COLOR_SEPARATOR                   [UIColor colorWithRed: 48.0/255.0 green: 48.0/255.0 blue: 50.0/255.0 alpha:1.0]
#define COLOR_DISABLE_TEXT_COLOR          [UIColor colorWithRed: 115.0/255.0 green: 114.0/255.0 blue: 120.0/255.0 alpha:1.0]


// ******************************* Internal Constants. **************************************
typedef enum
{
    TIMER_DELAY,
    TIMER_REAL,
    
} TIMER_TYPE;

typedef enum
{
    VIEW_MAIN,
    VIEW_EDIT,
    
} VIEW_INDEX;

// ******************************* Messages. **************************************************
#define MSG_INVALID_TIMER_NAME              @"Please enter a timer name."
#define MSG_INVALID_TIMER_INTERVAL          @"Please enter a time."

#endif
