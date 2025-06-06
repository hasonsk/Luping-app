import bcrypt from "bcryptjs";
import NodeGeocoder from "node-geocoder";

import User from "../models/userModel.js";
import Restaurant from "../models/restaurantModel.js";
import Dish from "../models/dishModel.js";
import Post from "../models/postModel.js";
import Like from "../models/likeModel.js";

// Cấu hình Geocoder
const geocoderOptions = {
  provider: "openstreetmap",
};

const seedUsers = async () => {
  const users = [
    {
      username: "adminuser",
      email: "admin@example.com",
      password: await bcrypt.hash("Admin@123", 10),
      role: "admin",
      profile: {
        full_name: "Admin User",
        date_of_birth: new Date("1980-01-01"),
        phone_number: "+84912345678",
        avatar:
          "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733547284/default-avatar_vqnong.jpg",
      },
    },
    {
      username: "johndoe",
      email: "johndoe@example.com",
      password: await bcrypt.hash("User@123", 10),
      role: "user",
      profile: {
        full_name: "John Doe",
        date_of_birth: new Date("1990-05-15"),
        phone_number: "+84987654321",
        avatar:
          "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733542335/kantan_lunch/avatars/eqozecoerlnitx3mdetu.png",
      },
    },
    {
      username: "janedoe",
      email: "janedoe@example.com",
      password: await bcrypt.hash("User@123", 10),
      role: "user",
      profile: {
        full_name: "Jane Doe",
        date_of_birth: new Date("1992-07-20"),
        phone_number: "+84911223344",
        avatar:
          "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733547284/default-avatar_vqnong.jpg",
      },
    },
    // Add more users...
  ];
  const createdUsers = await User.insertMany(users);
  return {
    admin: createdUsers[0]._id,
    user1: createdUsers[1]._id,
    user2: createdUsers[2]._id,
    // Add more user Ids...
  };
};

const seedRestaurants = async (userIds) => {
  const restaurants = [
    {
      name: "hàng quà Restaurant - Asian Fusion Food & Coffee",
      address: "13, Hàng Bông, Hàng Trống, Hoàn Kiếm, Hà Nội, Vietnam",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733536704/kantan_lunch/restaurants/kqfz2t3i9jauumz442kd.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548028/hang-qua-on-13-hang-bong_fhairn.jpg",
      ],
      admin_id: userIds.admin,
      phone_number: "+84123456789",
      open_time: "09:00",
      close_time: "22:00",
      location: {
        type: "Point",
        coordinates: [105.84701888248215, 21.030209039234084],
      },
    },
    {
      name: "The Gourmet Corner Restaurant",
      address: "22, Ta Hien, Hoan Kiem, Hanoi, Vietnam",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548063/images_msrhwg.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548100/restaurant_n2rebq.jpg",
      ],
      admin_id: userIds.admin,
      phone_number: "+84987654321",
      open_time: "10:00",
      close_time: "22:00",
      location: {
        type: "Point",
        coordinates: [105.852058, 21.0346357],
      },
    },
    {
      name: "Gia Ngư Restaurant",
      address: "27, Gia Ngu, Hoan Kiem, Hanoi, Vietnam",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548150/caption_z1lgwh.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548168/photo5jpg_fv9l1r.jpg",
      ],
      admin_id: userIds.admin,
      phone_number: "+84911223344",
      open_time: "12:00",
      close_time: "21:00",
      location: {
        type: "Point",
        coordinates: [105.8524553, 21.033057],
      },
    },
    // Add more restaurants...
  ];

  const createdRestaurants = await Restaurant.insertMany(restaurants);
  return {
    restaurant1: createdRestaurants[0]._id,
    restaurant2: createdRestaurants[1]._id,
    restaurant3: createdRestaurants[2]._id,
    // Add more restaurant Ids...
  };
};

const seedDishes = async (restaurantIds) => {
  const dishes = [
    {
      name: "寿司盛り合わせ",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741565/sushi-1_muqgmf.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741565/sushi-2_og0qoh.jpg",
      ],
      price: 1500,
      restaurant_id: restaurantIds.restaurant1,
    },
    {
      name: "ラーメン特選",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741639/ramen-1_rlo9nu.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741640/ramen-2_tspua4.jpg",
      ],
      price: 1200,
      restaurant_id: restaurantIds.restaurant2,
    },
    {
      name: "天ぷらセット",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741737/tempura-1_p21rhx.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733741736/tempura-2_y9bpzo.jpg",
      ],
      price: 1800,
      restaurant_id: restaurantIds.restaurant3,
    },
    // Add more dishes...
  ];
  const createdDishes = await Dish.insertMany(dishes);
  return {
    dish1: createdDishes[0]._id,
    dish2: createdDishes[1]._id,
    dish3: createdDishes[2]._id,
    // Add more dish Ids...
  };
};

const seedFeedback = async (userIds, restaurantIds) => {
  const feedbacks = [
    {
      type: "Feedback",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548219/cach-lam-bun-1_sudxnc.jpg",
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548228/bun-tuoi-soi-to-bun-bo_ksgm6z.jpg",
      ],
      content:
        "このレストランで素晴らしい体験をしました！料理は美味しく、スタッフも親切でした。",
      user_id: userIds.user1,
      restaurant_id: restaurantIds.restaurant1,
      rating: 5,
    },
    // Add more feedbacks...
  ];
  const createdFeedbacks = await Post.insertMany(feedbacks);
  return {
    feedback1: createdFeedbacks[0]._id,
    // Add more feedbacks Ids...
  };
};

const seedDishFeedback = async (userIds, dishIds) => {
  const dishFeedbacks = [
    {
      type: "DishFeedback",
      media: [
        "https://res.cloudinary.com/dtjl7hjbe/image/upload/v1733548332/0yrg1d2m8q091_uz5klb.jpg",
      ],
      content: "最高の寿司を楽しみました！新鮮で美味しかったです。",
      user_id: userIds.user2,
      dish_id: dishIds.dish1,
      rating: 5,
    },
    // Add more dish feedbacks...
  ];
  const createdDishFeedbacks = await Post.insertMany(dishFeedbacks);
  return {
    dishFeedback1: createdDishFeedbacks[0]._id,
    // Add more dish feedback Ids...
  };
};

const seedComments = async (userIds, postIds) => {
  const comments = [
    {
      type: "Comment",
      media: [],
      content: "本当に素晴らしいサービスですね。",
      user_id: userIds.user2,
      post_id: postIds.feedback1,
    },
    // Add more comments...
  ];
  const createdComments = await Post.insertMany(comments);
  return {
    comment1: createdComments[0]._id,
    // Add more comment Ids...
  };
};

const seedPosts = async (userIds, restaurantIds, dishIds) => {
  const feedbackIds = await seedFeedback(userIds, restaurantIds);

  const dishFeedbackIds = await seedDishFeedback(userIds, dishIds);

  const commentIds = await seedComments(userIds, feedbackIds);
  return { feedbackIds, dishFeedbackIds, commentIds };
};

const seedLikes = async (userIds, postIds) => {
  const likes = [
    {
      post_id: postIds.feedback1,
      user_id: userIds.user2,
    },
    {
      post_id: postIds.dishFeedback1,
      user_id: userIds.user1,
    },
    // Add more likes...
  ];
  return await Like.insertMany(likes);
};

const seedDB = async () => {
  try {
    const userCount = await User.countDocuments();
    const restaurantCount = await Restaurant.countDocuments();

    if (userCount > 0 || restaurantCount > 0) {
      return;
    }

    const createdUserIds = await seedUsers();

    const createdRestaurantIds = await seedRestaurants(createdUserIds);

    const createdDisheIds = await seedDishes(createdRestaurantIds);

    const createdPostIds = await seedPosts(
      createdUserIds,
      createdRestaurantIds,
      createdDisheIds,
    );

    // Aggregate Post IDs for Likes
    const postIds = {
      ...createdPostIds.feedbackIds,
      ...createdPostIds.dishFeedbackIds,
      ...createdPostIds.commentIds,
    };

    await seedLikes(createdUserIds, postIds);

    console.log("Seed Data Complete!");
  } catch (err) {
    console.error("Error seeding data:", err.message);
    process.exit(1);
  }
};

export default seedDB;
