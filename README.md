# turnstr2-ios


Comment marks : 
//>> Kamal
//-> Ankit
//--> Ketan
Guys please coment the changes you are doing in existin function with your perticular comment sign

Init a storyboard 

let vc = Storyboards.liveStoryboard.initialVC()
or
feeds = Storyboards.profileStoryboard.initialVC(with: StoryboardIds.example)

Storyboards &  StoryboardIds are enum classes.

//->Ankit (14Jul17)

Init a Cube for Images
Call following method to get a UIView for cube

let transformView = AITransformView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: 300), cube_size: 100)

transformView?.backgroundColor = UIColor.white

transformView?.setup(withUrls: ["https://s3-us-west-2.amazonaws.com/turnstr2-staging/users/avatar_face1s/000/000/003/medium/user_avatar_face1_?1499875613", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face1_media/000/000/007/thumb/img2.png?1499097845", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face1_media/000/000/016/thumb/dairies.jpg?1499980195", "https://s3-us-west-2.amazonaws.com/turnstr2-staging/stories/face4_media/000/000/016/thumb/icecrm.jpeg?1499980196"])

self.view.addSubview(transformView!)

//cube_size :- size of the cube
NOTES:- Make sure size of the cube is less then or equal to the frame as cube remains in center of the ParentView.
