with open('/Users/mac/Library/Developer/CoreSimulator/Devices/C24E78F5-DBE1-4F60-8F95-88D6C3D8E046/data/Containers/Data/Application/5B4743FC-A180-47ED-BD85-9C4FFC855160/Documents/vocabulary/words.txt', 'r+') as fwords:
    words = set(fwords.readlines())
    fwords.seek(0,2)
    with open('/Users/mac/Library/Developer/CoreSimulator/Devices/C24E78F5-DBE1-4F60-8F95-88D6C3D8E046/data/Containers/Data/Application/5B4743FC-A180-47ED-BD85-9C4FFC855160/Documents/vocabulary/words.json', 'a+') as fjson:
            for i in range(10001,10128):
                with open('/Users/mac/Library/Developer/CoreSimulator/Devices/C24E78F5-DBE1-4F60-8F95-88D6C3D8E046/data/Containers/Data/Application/5B4743FC-A180-47ED-BD85-9C4FFC855160/Documents/vocabulary/{0}.txt'.format(i), 'r') as f1:
                    with open('/Users/mac/Library/Developer/CoreSimulator/Devices/C24E78F5-DBE1-4F60-8F95-88D6C3D8E046/data/Containers/Data/Application/5B4743FC-A180-47ED-BD85-9C4FFC855160/Documents/vocabulary/{0}.json'.format(i), 'r') as f2:
                        nwords = f1.readlines()
                        njsons = f2.readlines()
                        for word, json in zip(nwords, njsons):
                            #print("已存在{0}:{1}".format(word,json))
                            if word not in words:
                                words.add(word)
                                fwords.write(word)
                                fjson.write(json)
                            else:
                                pass
                                #print("已存在{0}".format(word))
                print("words:{0}".format(len(words)))



