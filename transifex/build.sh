# Triggers a build of readthedocs sub-projects for each supported language
# Token and webhook variables should be exported via a .env file
curl -X POST -d "branches=stable" -d "token=$ARABIC" $ARABIC_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$FILIPINO" $FILIPINO_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$FRENCH" $FRENCH_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$GERMAN" $GERMAN_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$GREEK" $GREEK_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$ITALIAN" $ITALIAN_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$JAPANESE" $JAPANESE_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$KOREAN" $KOREAN_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$PORTUGUESE" $PORTUGUESE_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$RUSSIAN" $RUSSIAN_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$SIMPLIFIED_CHINESE" $SIMPLIFIED_CHINESE_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$SPANISH" $SPANISH_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$TRADITIONAL_CHINESE" $TRADITIONAL_CHINESE_WEBHOOK
curl -X POST -d "branches=stable" -d "token=$VIETNAMESE" $VIETNAMESE_WEBHOOK
